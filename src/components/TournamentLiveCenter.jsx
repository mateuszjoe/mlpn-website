import React, { useCallback, useEffect, useRef, useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { tournamentCatalog } from '../data/tournamentDemo';
import { loadTournamentDocuments, saveTournamentDocument, TournamentRepositoryError } from '../services/tournamentRepository';
import TournamentCenter from '../pages/TournamentCenter';

const fallbackCatalog = () => tournamentCatalog.map(tournament => ({ ...tournament, _revision: 0 }));
const mergeCatalog = documents => {
  const savedSlugs = new Set(documents.map(tournament => tournament.slug));
  return [...fallbackCatalog().filter(tournament => !savedSlugs.has(tournament.slug)), ...documents];
};

export default function TournamentLiveCenter(props) {
  const { user, isAdmin, isAccountActive } = useAuth();
  const canManage = Boolean(user && isAdmin === true && isAccountActive === true);
  const [catalog, setCatalog] = useState(fallbackCatalog);
  const [storageReady, setStorageReady] = useState(false);
  const [loadError, setLoadError] = useState('');
  const mounted = useRef(false);
  const requestNumber = useRef(0);
  const currentRequest = useRef(null);
  const saving = useRef(new Set());
  const access = useRef({ canManage, storageReady });
  const editing = useRef(false);
  access.current = { canManage, storageReady };
  editing.current = /\/organizator\/?$/.test(String(props.route || ''));

  const reload = useCallback(async ({ force = false } = {}) => {
    if (!force && (editing.current || document.visibilityState === 'hidden' || saving.current.size)) return null;
    const number = ++requestNumber.current;
    currentRequest.current?.abort();
    const controller = new AbortController();
    currentRequest.current = controller;
    try {
      const documents = await loadTournamentDocuments({ signal: controller.signal });
      if (!mounted.current || number !== requestNumber.current || (!force && editing.current)) return null;
      setCatalog(mergeCatalog(documents));
      setStorageReady(true); setLoadError('');
      access.current.storageReady = true;
      return documents;
    } catch (error) {
      if (mounted.current && number === requestNumber.current && (force || !editing.current)) {
        setStorageReady(false); setLoadError(error.message);
        access.current.storageReady = false;
      }
      throw error;
    } finally {
      if (number === requestNumber.current) currentRequest.current = null;
    }
  }, []);

  useEffect(() => {
    mounted.current = true;
    reload({ force: true }).catch(() => {});
    const refresh = () => { reload().catch(() => {}); };
    const interval = window.setInterval(refresh, 20000);
    window.addEventListener('focus', refresh);
    document.addEventListener('visibilitychange', refresh);
    return () => {
      mounted.current = false; requestNumber.current += 1;
      currentRequest.current?.abort();
      window.clearInterval(interval);
      window.removeEventListener('focus', refresh);
      document.removeEventListener('visibilitychange', refresh);
    };
  }, [reload]);

  const save = useCallback(async (next, expectedRevision) => {
    if (!access.current.canManage) throw new TournamentRepositoryError('Brak uprawnień do zapisu turnieju.', 'FORBIDDEN');
    if (!access.current.storageReady) throw new TournamentRepositoryError('Najpierw wczytaj aktualne dane turniejów.', 'NOT_READY');
    if (saving.current.has(next?.slug)) throw new TournamentRepositoryError('Trwa zapis tego turnieju.', 'SAVE_PENDING');
    saving.current.add(next?.slug);
    requestNumber.current += 1; currentRequest.current?.abort();
    try {
      const saved = await saveTournamentDocument(next, expectedRevision);
      if (mounted.current) setCatalog(current => current.some(tournament => tournament.slug === saved.slug)
        ? current.map(tournament => tournament.slug === saved.slug ? saved : tournament)
        : [...current, saved]);
      return saved;
    } finally { saving.current.delete(next?.slug); }
  }, []);
  const create = useCallback(next => save(next, 0), [save]);
  const manualReload = useCallback(() => reload({ force: true }), [reload]);

  return <TournamentCenter {...props} catalog={catalog} canManage={canManage}
    onSave={save} onCreate={create} storageReady={storageReady} loadError={loadError} onReload={manualReload} />;
}
