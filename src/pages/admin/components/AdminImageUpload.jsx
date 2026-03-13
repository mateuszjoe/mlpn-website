import React, { useState } from "react";
import { Upload, Image } from "lucide-react";
import { supabase } from "../../../lib/supabase";

export default function AdminImageUpload({ bucket, folder, currentUrl, onUpload, darkMode, label = "Zdjęcie" }) {
  const [uploading, setUploading] = useState(false);
  const [preview, setPreview] = useState(currentUrl);
  const [error, setError] = useState(null);

  const borderColor = darkMode ? "border-white/10" : "border-gray-300";

  const handleUpload = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    if (file.size > 2 * 1024 * 1024) {
      setError("Plik za duży (max 2MB)");
      return;
    }

    setUploading(true);
    setError(null);

    const ext = file.name.split(".").pop().toLowerCase();
    const fileName = `${folder}/${Date.now()}_${Math.random().toString(36).slice(2, 8)}.${ext}`;

    const { error: uploadError } = await supabase.storage
      .from(bucket)
      .upload(fileName, file, { upsert: true });

    if (uploadError) {
      setError("Błąd uploadu: " + uploadError.message);
      setUploading(false);
      return;
    }

    const { data } = supabase.storage.from(bucket).getPublicUrl(fileName);
    setPreview(data.publicUrl);
    onUpload(data.publicUrl);
    setUploading(false);
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
      {error && <p className="text-xs text-red-400">{error}</p>}
    </div>
  );
}
