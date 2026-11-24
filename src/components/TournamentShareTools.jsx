import React, { useEffect, useId, useRef, useState } from "react";
import { Bell, Check, Copy, Download, QrCode, Star } from "lucide-react";
import QRCode from "qrcode";
import {
  getTournamentNotificationSupport, isLocalTournamentPreview, loadTournamentFollowing,
  saveTournamentFollowing, showTournamentTestNotification, tournamentUrl,
} from "../lib/tournamentNotifications";
import "./TournamentShareTools.css";

export default function TournamentShareTools({ tournament, basePath = "/turnieje" }) {
  const [preferences, setPreferences] = useState(() => loadTournamentFollowing(tournament));
  const [qr, setQr] = useState("");
  const [qrOpen, setQrOpen] = useState(false);
  const [copyStatus, setCopyStatus] = useState("");
  const [notice, setNotice] = useState("");
  const [busy, setBusy] = useState(false);
  const urlRef = useRef(null);
  const id = useId();
  const url = tournamentUrl(tournament, basePath);
  const support = getTournamentNotificationSupport();

  useEffect(() => {
    setPreferences(loadTournamentFollowing(tournament));
  }, [tournament]);

  useEffect(() => {
    setNotice(""); setQr(""); setCopyStatus("");
  }, [url]);

  useEffect(() => {
    if (!qrOpen) return undefined;
    let cancelled = false;
    QRCode.toDataURL(url, { width: 512, margin: 4, errorCorrectionLevel: "M", color: { dark: "#0f2a4aff", light: "#ffffffff" } })
      .then(image => { if (!cancelled) setQr(image); })
      .catch(() => { if (!cancelled) setCopyStatus("Nie udało się przygotować kodu QR. Możesz skopiować link poniżej."); });
    return () => { cancelled = true; };
  }, [qrOpen, url]);

  function update(next) {
    setPreferences(next);
    setNotice(saveTournamentFollowing(tournament, next)
      ? "Wybór zapisany na tym urządzeniu."
      : "Wybór działa teraz, ale przeglądarka nie pozwoliła go zapisać na później.");
  }

  async function copy() {
    try {
      if (!navigator.clipboard?.writeText) throw new Error("Clipboard unavailable");
      await navigator.clipboard.writeText(url);
      setCopyStatus("Link skopiowany.");
    } catch {
      urlRef.current?.focus(); urlRef.current?.select();
      setCopyStatus("Zaznaczyłem link. Skopiuj go z pola ręcznie.");
    }
  }

  async function testNotification() {
    if (busy) return;
    setBusy(true); setNotice("");
    try {
      await showTournamentTestNotification(tournament, basePath);
      setNotice("Powiadomienie testowe przekazano przeglądarce. Jeśli go nie widać, sprawdź ustawienia powiadomień i tryb skupienia systemu.");
    } catch (error) {
      setNotice(error.message || "Nie udało się pokazać powiadomienia. Spróbuj ponownie.");
    } finally { setBusy(false); }
  }

  return <div className="tour-share">
    <details className="tour-share-section" onToggle={event => setQrOpen(event.currentTarget.open)}>
      <summary><QrCode size={17} aria-hidden="true" /><span>Link i kod QR</span></summary>
      <div className="tour-share-content tour-share-link-content">
        <div className="tour-share-qr">{qr ? <img src={qr} alt={`Kod QR do turnieju ${tournament.name}`} width="176" height="176" /> : <span>Przygotowanie kodu QR…</span>}</div>
        <div className="tour-share-copy">
          <label htmlFor={`${id}-url`}>Bezpośredni link do turnieju</label>
          <input id={`${id}-url`} ref={urlRef} value={url} readOnly onFocus={event => event.target.select()} />
          <div className="tour-share-actions">
            <button type="button" onClick={copy}><Copy size={15} aria-hidden="true" />Kopiuj link</button>
            {qr && <a href={qr} download={`mlpn-turniej-${tournament.slug}-qr.png`}><Download size={15} aria-hidden="true" />Pobierz QR</a>}
          </div>
          {isLocalTournamentPreview() && <p>To adres lokalny, dostępny na tym komputerze. Skanowanie telefonem będzie działać po udostępnieniu podglądu pod adresem dostępnym z telefonu.</p>}
          <p className="tour-share-status" role="status">{copyStatus}</p>
        </div>
      </div>
    </details>
    <details className="tour-share-section">
      <summary><Bell size={17} aria-hidden="true" /><span>Obserwuj i powiadomienia</span>{preferences.following || preferences.teamIds.length ? <span className="tour-share-count">{preferences.following ? "Cały turniej" : `${preferences.teamIds.length} drużyn`}</span> : null}</summary>
      <div className="tour-share-content">
        <p>Wybierz cały turniej lub konkretne drużyny. W tej wersji zapisujemy wybór na tym urządzeniu; automatyczna wysyłka push będzie podłączona w kolejnym etapie.</p>
        <label className="tour-share-follow"><input type="checkbox" checked={preferences.following} onChange={event => update({ ...preferences, following: event.target.checked })} /><Star size={16} aria-hidden="true" /><span>Obserwuj cały turniej</span></label>
        {Boolean(tournament.teams?.length) && <fieldset className="tour-share-teams"><legend>Obserwowane drużyny</legend>
          {tournament.teams.map(team => <label key={team.id}><input type="checkbox" checked={preferences.teamIds.includes(team.id)} onChange={event => update({ ...preferences, teamIds: event.target.checked ? [...preferences.teamIds, team.id] : preferences.teamIds.filter(value => value !== team.id) })} /><span>{team.name}</span>{preferences.teamIds.includes(team.id) && <Check size={14} aria-hidden="true" />}</label>)}
        </fieldset>}
        <div className="tour-share-test">
          <button type="button" disabled={busy || !support.supported} onClick={testNotification}><Bell size={15} aria-hidden="true" />{busy ? "Uruchamianie…" : "Pokaż powiadomienie testowe"}</button>
          <p>{support.supported ? "Test pokaże jedno powiadomienie na tym urządzeniu. Nie zapisuje Cię jeszcze do wysyłki push." : support.reason}</p>
        </div>
        <p className="tour-share-status" role="status">{notice}</p>
      </div>
    </details>
  </div>;
}
