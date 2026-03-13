import React, { useCallback, useEffect, useMemo, useState } from "react";
import { ImagePlus, Images, Loader2, Star, Trash2 } from "lucide-react";
import { supabase } from "../../../lib/supabase";

const BUCKET = "match-galleries";
const MAX_FILE_SIZE = 8 * 1024 * 1024;

function sortPhotos(rows) {
  return (rows || [])
    .slice()
    .sort((a, b) => {
      const orderDiff = (a.display_order || 0) - (b.display_order || 0);
      if (orderDiff !== 0) return orderDiff;
      return String(a.created_at || "").localeCompare(String(b.created_at || ""));
    });
}

function buildAlbumTitle(match) {
  return `${match.home_team_name} - ${match.away_team_name}`;
}

function sanitizeFileName(name) {
  return String(name || "photo")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-zA-Z0-9._-]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .toLowerCase();
}

function extractStoragePath(publicUrl) {
  try {
    const url = new URL(publicUrl);
    const marker = `/storage/v1/object/public/${BUCKET}/`;
    const idx = url.pathname.indexOf(marker);
    if (idx === -1) return null;
    return decodeURIComponent(url.pathname.slice(idx + marker.length));
  } catch {
    return null;
  }
}

function announceGalleryChange() {
  window.dispatchEvent(new CustomEvent("mlpn:match-galleries-updated"));
}

export default function AdminMatchGalleryManager({ match, darkMode, onAlert }) {
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [busyPhotoId, setBusyPhotoId] = useState(null);
  const [album, setAlbum] = useState(null);
  const [photos, setPhotos] = useState([]);

  const card = darkMode ? "border-white/10 bg-black/10" : "border-gray-200 bg-gray-50";
  const textMuted = darkMode ? "text-gray-400" : "text-gray-500";
  const btnGhost = darkMode
    ? "border-white/10 bg-white/5 text-gray-200 hover:bg-white/10"
    : "border-gray-200 bg-white text-gray-700 hover:bg-gray-50";

  const syncAlbumMeta = useCallback(async (albumRow, photoRows) => {
    if (!albumRow?.id) return albumRow;

    const nextCover = photoRows[0]?.photo_url || null;
    const nextPublished = photoRows.length > 0;
    const patch = {};

    if ((albumRow.cover_photo_url || null) !== nextCover) {
      patch.cover_photo_url = nextCover;
    }
    if ((albumRow.is_published ?? false) !== nextPublished) {
      patch.is_published = nextPublished;
    }
    if (nextPublished && !albumRow.published_at) {
      patch.published_at = new Date().toISOString();
    }

    if (Object.keys(patch).length > 0) {
      const { error } = await supabase.from("gallery_albums").update(patch).eq("id", albumRow.id);
      if (error) throw error;
      return { ...albumRow, ...patch };
    }

    return albumRow;
  }, []);

  const loadGallery = useCallback(async () => {
    if (!match?.id) {
      setAlbum(null);
      setPhotos([]);
      setLoading(false);
      return;
    }

    setLoading(true);
    try {
      const { data, error } = await supabase
        .from("gallery_albums")
        .select(`
          id,
          title,
          description,
          cover_photo_url,
          is_published,
          published_at,
          created_at,
          gallery_photos (
            id,
            photo_url,
            caption,
            display_order,
            created_at
          )
        `)
        .eq("match_id", match.id)
        .order("created_at", { ascending: true })
        .limit(1);

      if (error) throw error;

      const albumRow = data?.[0] || null;
      const nextPhotos = sortPhotos(albumRow?.gallery_photos || []);
      const syncedAlbum = albumRow ? await syncAlbumMeta(albumRow, nextPhotos) : null;

      setAlbum(syncedAlbum);
      setPhotos(nextPhotos);
    } catch (err) {
      onAlert?.({ type: "error", message: err.message || "Nie udało się załadować galerii meczu." });
      setAlbum(null);
      setPhotos([]);
    } finally {
      setLoading(false);
      setBusyPhotoId(null);
    }
  }, [match?.id, onAlert, syncAlbumMeta]);

  useEffect(() => {
    loadGallery();
  }, [loadGallery]);

  const ensureAlbum = useCallback(async () => {
    if (album?.id) return album;

    const payload = {
      title: buildAlbumTitle(match),
      description: null,
      match_id: match.id,
      season_id: match.season_id,
      cover_photo_url: null,
      is_published: false,
    };

    const { data, error } = await supabase
      .from("gallery_albums")
      .insert(payload)
      .select("id, title, description, cover_photo_url, is_published, published_at, created_at")
      .single();

    if (error) throw error;

    setAlbum(data);
    return data;
  }, [album, match]);

  async function handleFilesSelected(e) {
    const files = Array.from(e.target.files || []);
    e.target.value = "";
    if (!files.length) return;

    const invalidType = files.find((file) => !String(file.type || "").startsWith("image/"));
    if (invalidType) {
      onAlert?.({ type: "error", message: `Plik "${invalidType.name}" nie jest obrazem.` });
      return;
    }

    const tooLarge = files.find((file) => file.size > MAX_FILE_SIZE);
    if (tooLarge) {
      onAlert?.({
        type: "error",
        message: `Plik "${tooLarge.name}" jest za duży. Limit to 8 MB na zdjęcie.`,
      });
      return;
    }

    setUploading(true);
    try {
      const ensuredAlbum = await ensureAlbum();
      const rows = [];

      for (let index = 0; index < files.length; index += 1) {
        const file = files[index];
        const ext = String(file.name.split(".").pop() || "jpg").toLowerCase();
        const objectPath = `${match.season_id || "season"}/${match.id}/${Date.now()}_${index}_${sanitizeFileName(file.name.replace(/\.[^.]+$/, ""))}.${ext}`;

        const { error: uploadError } = await supabase.storage
          .from(BUCKET)
          .upload(objectPath, file, { upsert: false });

        if (uploadError) throw uploadError;

        const { data: publicUrl } = supabase.storage.from(BUCKET).getPublicUrl(objectPath);
        rows.push({
          album_id: ensuredAlbum.id,
          photo_url: publicUrl?.publicUrl || "",
          display_order: photos.length + index + 1,
        });
      }

      const { error: insertError } = await supabase.from("gallery_photos").insert(rows);
      if (insertError) throw insertError;

      await loadGallery();
      announceGalleryChange();
      onAlert?.({
        type: "success",
        message: files.length === 1 ? "Dodano 1 zdjęcie do meczu." : `Dodano ${files.length} zdjęcia do meczu.`,
      });
    } catch (err) {
      onAlert?.({ type: "error", message: err.message || "Nie udało się dodać zdjęć." });
    } finally {
      setUploading(false);
    }
  }

  async function handleDeletePhoto(photo) {
    if (!photo?.id) return;
    if (!window.confirm("Usunąć to zdjęcie z galerii meczu?")) return;

    setBusyPhotoId(photo.id);
    try {
      const storagePath = extractStoragePath(photo.photo_url);
      if (storagePath) {
        await supabase.storage.from(BUCKET).remove([storagePath]);
      }

      const { error } = await supabase.from("gallery_photos").delete().eq("id", photo.id);
      if (error) throw error;

      await loadGallery();
      announceGalleryChange();
      onAlert?.({ type: "success", message: "Zdjęcie zostało usunięte." });
    } catch (err) {
      onAlert?.({ type: "error", message: err.message || "Nie udało się usunąć zdjęcia." });
      setBusyPhotoId(null);
    }
  }

  async function handleSetCover(photo) {
    if (!album?.id || !photo?.photo_url) return;
    setBusyPhotoId(photo.id);
    try {
      const { error } = await supabase
        .from("gallery_albums")
        .update({ cover_photo_url: photo.photo_url, is_published: true })
        .eq("id", album.id);

      if (error) throw error;

      await loadGallery();
      announceGalleryChange();
      onAlert?.({ type: "success", message: "Ustawiono zdjęcie okładkowe galerii." });
    } catch (err) {
      onAlert?.({ type: "error", message: err.message || "Nie udało się ustawić okładki." });
      setBusyPhotoId(null);
    }
  }

  const coverUrl = useMemo(() => album?.cover_photo_url || photos[0]?.photo_url || "", [album, photos]);

  return (
    <div className={`rounded-xl border p-4 ${card}`}>
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div>
          <div className="flex items-center gap-2">
            <Images size={16} />
            <h4 className="font-semibold text-sm">Galeria zdjęć</h4>
          </div>
          <p className={`text-xs mt-1 ${textMuted}`}>
            Dodane zdjęcia będą widoczne publicznie przy meczu i w zakładce galerii ligi.
          </p>
        </div>

        <label
          className={`inline-flex items-center gap-2 px-3 py-2 rounded-xl border text-sm cursor-pointer transition-colors ${btnGhost} ${
            uploading ? "opacity-60 pointer-events-none" : ""
          }`}
        >
          {uploading ? <Loader2 size={15} className="animate-spin" /> : <ImagePlus size={15} />}
          {uploading ? "Przesyłanie..." : "Dodaj zdjęcia"}
          <input
            type="file"
            accept="image/*"
            multiple
            onChange={handleFilesSelected}
            className="hidden"
            disabled={uploading}
          />
        </label>
      </div>

      <div className={`mt-3 rounded-xl border p-3 ${darkMode ? "border-white/10 bg-white/5" : "border-gray-200 bg-white"}`}>
        {loading ? (
          <div className={`flex items-center gap-2 text-sm ${textMuted}`}>
            <Loader2 size={16} className="animate-spin" />
            Ładowanie galerii...
          </div>
        ) : photos.length === 0 ? (
          <div className={textMuted}>
            Brak zdjęć dla tego meczu. Możesz dodać kilka plików naraz.
          </div>
        ) : (
          <div className="space-y-3">
            <div className="flex flex-wrap items-center gap-2 text-xs">
              <span className={`px-2 py-1 rounded-full border ${darkMode ? "border-emerald-400/30 bg-emerald-500/10 text-emerald-300" : "border-emerald-200 bg-emerald-50 text-emerald-700"}`}>
                Zdjęć: {photos.length}
              </span>
              {album?.is_published && (
                <span className={`px-2 py-1 rounded-full border ${darkMode ? "border-blue-400/30 bg-blue-500/10 text-blue-200" : "border-blue-200 bg-blue-50 text-blue-700"}`}>
                  Opublikowana
                </span>
              )}
              <span className={textMuted}>Album: {album?.title || buildAlbumTitle(match)}</span>
            </div>

            {coverUrl ? (
              <div className="rounded-xl overflow-hidden border border-white/10 bg-black/10 max-w-xs">
                <img src={coverUrl} alt="" className="w-full h-36 object-cover" />
              </div>
            ) : null}

            <div className="grid grid-cols-2 md:grid-cols-4 xl:grid-cols-5 gap-3">
              {photos.map((photo) => {
                const isCover = coverUrl && coverUrl === photo.photo_url;
                const isBusy = busyPhotoId === photo.id;
                return (
                  <div key={photo.id} className={`rounded-xl border overflow-hidden ${darkMode ? "border-white/10 bg-black/20" : "border-gray-200 bg-gray-50"}`}>
                    <div className="aspect-[4/3] bg-black/10">
                      <img src={photo.photo_url} alt="" className="w-full h-full object-cover" />
                    </div>
                    <div className="p-2 space-y-2">
                      <div className={`text-[11px] ${textMuted}`}>
                        Kolejność: {photo.display_order || 0}
                      </div>
                      <div className="flex gap-2">
                        <button
                          type="button"
                          onClick={() => handleSetCover(photo)}
                          disabled={isBusy || isCover}
                          className={`flex-1 inline-flex items-center justify-center gap-1 px-2 py-1.5 rounded-lg border text-xs ${
                            isCover
                              ? darkMode
                                ? "border-amber-400/30 bg-amber-500/10 text-amber-200"
                                : "border-amber-200 bg-amber-50 text-amber-700"
                              : btnGhost
                          } ${isBusy ? "opacity-60 pointer-events-none" : ""}`}
                        >
                          <Star size={12} />
                          {isCover ? "Okładka" : "Ustaw okładkę"}
                        </button>
                        <button
                          type="button"
                          onClick={() => handleDeletePhoto(photo)}
                          disabled={isBusy}
                          className={`inline-flex items-center justify-center px-2 py-1.5 rounded-lg border text-xs ${
                            darkMode
                              ? "border-red-500/30 bg-red-500/10 text-red-300 hover:bg-red-500/20"
                              : "border-red-200 bg-red-50 text-red-700 hover:bg-red-100"
                          } ${isBusy ? "opacity-60 pointer-events-none" : ""}`}
                          title="Usuń zdjęcie"
                        >
                          {isBusy ? <Loader2 size={12} className="animate-spin" /> : <Trash2 size={12} />}
                        </button>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
