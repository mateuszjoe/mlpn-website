import React, { useEffect, useState } from "react";
import { Upload, Image } from "lucide-react";
import { supabase } from "../../../lib/supabase";

function sanitizeBaseName(fileName) {
  const raw = String(fileName || "").replace(/\.[^.]+$/, "");
  const cleaned = raw
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-zA-Z0-9_-]+/g, "-")
    .replace(/-+/g, "-")
    .replace(/^-|-$/g, "");

  return cleaned || "image";
}

function fitIntoBox(width, height, maxSide) {
  if (!maxSide || Math.max(width, height) <= maxSide) {
    return { width, height };
  }

  const scale = maxSide / Math.max(width, height);
  return {
    width: Math.max(1, Math.round(width * scale)),
    height: Math.max(1, Math.round(height * scale)),
  };
}

async function loadImageElement(file) {
  const objectUrl = URL.createObjectURL(file);

  try {
    const image = await new Promise((resolve, reject) => {
      const img = new window.Image();
      img.onload = () => resolve(img);
      img.onerror = () => reject(new Error("Nie udalo sie odczytac obrazu."));
      img.src = objectUrl;
    });

    return image;
  } finally {
    URL.revokeObjectURL(objectUrl);
  }
}

async function convertFileToWebp(file, maxSide = 1024, quality = 0.92) {
  const image = await loadImageElement(file);
  const target = fitIntoBox(image.naturalWidth || image.width, image.naturalHeight || image.height, maxSide);
  const canvas = document.createElement("canvas");
  canvas.width = target.width;
  canvas.height = target.height;

  const ctx = canvas.getContext("2d", { alpha: true });
  if (!ctx) {
    throw new Error("Przegladarka nie obsluguje konwersji obrazow.");
  }

  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.drawImage(image, 0, 0, target.width, target.height);

  const blob = await new Promise((resolve) => {
    canvas.toBlob(resolve, "image/webp", quality);
  });

  if (!blob) {
    throw new Error("Nie udalo sie zapisac pliku jako WEBP.");
  }

  return new File([blob], `${sanitizeBaseName(file.name)}.webp`, {
    type: "image/webp",
    lastModified: Date.now(),
  });
}

export default function AdminImageUpload({
  bucket,
  folder,
  currentUrl,
  onUpload,
  darkMode,
  label = "Zdjęcie",
  maxFileSizeMB = 2,
  convertToWebp = false,
  webpMaxSide = 1024,
  helperText = "",
}) {
  const [uploading, setUploading] = useState(false);
  const [preview, setPreview] = useState(currentUrl);
  const [error, setError] = useState(null);

  const borderColor = darkMode ? "border-white/10" : "border-gray-300";

  useEffect(() => {
    setPreview(currentUrl);
  }, [currentUrl]);

  const handleUpload = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setUploading(true);
    setError(null);

    try {
      if (file.size > maxFileSizeMB * 1024 * 1024) {
        throw new Error(`Plik za duzy (max ${maxFileSizeMB}MB).`);
      }

      const uploadFile = convertToWebp
        ? await convertFileToWebp(file, webpMaxSide)
        : file;

      const ext = uploadFile.name.split(".").pop().toLowerCase();
      const fileName = `${folder}/${Date.now()}_${Math.random().toString(36).slice(2, 8)}.${ext}`;

      const { error: uploadError } = await supabase.storage
        .from(bucket)
        .upload(fileName, uploadFile, {
          upsert: true,
          contentType: uploadFile.type || undefined,
        });

      if (uploadError) {
        throw new Error("Blad uploadu: " + uploadError.message);
      }

      const { data } = supabase.storage.from(bucket).getPublicUrl(fileName);
      setPreview(data.publicUrl);
      onUpload(data.publicUrl);
    } catch (uploadError) {
      setError(uploadError.message || "Nie udalo sie przeslac pliku.");
    } finally {
      setUploading(false);
      e.target.value = "";
    }
  };

  return (
    <div className="space-y-2">
      <label className={`block text-sm font-medium ${darkMode ? "text-gray-300" : "text-gray-700"}`}>{label}</label>
      <div className="flex items-center gap-4">
        {preview ? (
          <img src={preview} alt="" className="w-16 h-16 object-contain rounded-xl bg-white/5 border border-white/10" />
        ) : (
          <div className={`w-16 h-16 rounded-xl border ${borderColor} flex items-center justify-center`}>
            <Image size={24} className="text-gray-500" />
          </div>
        )}
        <label className={`flex items-center gap-2 px-4 py-2 rounded-xl border ${borderColor} cursor-pointer hover:bg-white/5 transition-colors text-sm ${uploading ? "opacity-50 pointer-events-none" : ""}`}>
          <Upload size={16} />
          {uploading ? "Przesyłanie..." : "Wybierz plik"}
          <input type="file" accept="image/*" onChange={handleUpload} className="hidden" disabled={uploading} />
        </label>
      </div>
      {helperText && <p className={`text-xs ${darkMode ? "text-gray-400" : "text-gray-500"}`}>{helperText}</p>}
      {error && <p className="text-xs text-red-400">{error}</p>}
    </div>
  );
}
