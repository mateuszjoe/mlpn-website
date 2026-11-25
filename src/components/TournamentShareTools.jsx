import React, { useEffect, useId, useRef, useState } from "react";
import { Copy, Download, Share2 } from "lucide-react";
import QRCode from "qrcode";
import { tournamentUrl } from "../lib/tournamentNotifications";
import "./TournamentShareTools.css";

export default function TournamentShareTools({ tournament, basePath = "/turnieje" }) {
  const [qr, setQr] = useState("");
  const [qrOpen, setQrOpen] = useState(false);
  const [qrError, setQrError] = useState(false);
  const [copyStatus, setCopyStatus] = useState("");
  const urlRef = useRef(null);
  const id = useId();
  const url = tournamentUrl(tournament, basePath);

  useEffect(() => {
    setQr(""); setQrError(false); setCopyStatus("");
  }, [url]);

  useEffect(() => {
    if (!qrOpen) return undefined;
    let cancelled = false;
    QRCode.toDataURL(url, { width: 512, margin: 4, errorCorrectionLevel: "M", color: { dark: "#0f2a4aff", light: "#ffffffff" } })
      .then(image => { if (!cancelled) setQr(image); })
      .catch(() => { if (!cancelled) setQrError(true); });
    return () => { cancelled = true; };
  }, [qrOpen, url]);

  async function copy() {
    try {
      if (!navigator.clipboard?.writeText) throw new Error("Clipboard unavailable");
      await navigator.clipboard.writeText(url);
      setCopyStatus("Link skopiowany.");
    } catch {
      urlRef.current?.focus(); urlRef.current?.select();
      setCopyStatus("Skopiuj zaznaczony link.");
    }
  }

  return <div className="tour-share">
    <details className="tour-share-section" onToggle={event => setQrOpen(event.currentTarget.open)}>
      <summary><Share2 size={16} aria-hidden="true" /><span>Udostępnij</span></summary>
      <div className="tour-share-content tour-share-link-content">
        <div className="tour-share-qr">{qr ? <img src={qr} alt={`Kod QR do turnieju ${tournament.name}`} width="144" height="144" /> : <span role={qrError ? "status" : undefined}>{qrError ? "Kod QR niedostępny" : "Ładowanie…"}</span>}</div>
        <div className="tour-share-copy">
          <label htmlFor={`${id}-url`}>Link do turnieju</label>
          <input id={`${id}-url`} ref={urlRef} value={url} readOnly onFocus={event => event.target.select()} />
          <div className="tour-share-actions">
            <button type="button" onClick={copy}><Copy size={15} aria-hidden="true" />Kopiuj link</button>
            {qr && <a href={qr} download={`mlpn-turniej-${tournament.slug}-qr.png`}><Download size={15} aria-hidden="true" />Pobierz QR</a>}
          </div>
          <p className="tour-share-status" role="status">{copyStatus}</p>
        </div>
      </div>
    </details>
  </div>;
}
