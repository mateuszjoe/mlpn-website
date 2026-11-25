import { publicSupabase, supabase } from '../lib/supabase';
import { validateManagedTournament } from '../lib/tournamentManagement';

const COLUMNS = 'slug,document,revision,updated_at';
const READ_ERROR = 'Nie udało się odświeżyć turniejów. Pokazujemy ostatnio dostępne dane.';
const SAVE_ERROR = 'Nie udało się potwierdzić zapisu. Wczytaj aktualne dane przed ponowną próbą.';

export class TournamentRepositoryError extends Error {
  constructor(message, code) { super(message); this.name = 'TournamentRepositoryError'; this.code = code; }
}

function repositoryError(error, operation) {
  if (error instanceof TournamentRepositoryError) return error;
  if (operation === 'save' && ['40001', '23505'].includes(String(error?.code))) {
    return new TournamentRepositoryError('Dane turnieju zmieniły się. Wczytaj aktualną wersję i wprowadź zmianę ponownie.', 'CONFLICT');
  }
  if (operation === 'save' && ['42501', 'PGRST301', 'PGRST302'].includes(String(error?.code))) {
    return new TournamentRepositoryError('Brak uprawnień do zapisu turnieju.', 'FORBIDDEN');
  }
  if (operation === 'save' && String(error?.code) === '22023') {
    const message = typeof error.message === 'string' ? error.message.trim() : '';
    const isValidationMessage = message.length <= 240 && !/[\r\n]/.test(message) &&
      /^(Nieprawidłow|Przekroczono |Zbyt wielu |Powtórzon|Wynik musi |Brak drużyn |Nadchodzący mecz |Uczestnicy meczu |Karne są |Remis w fazie |Liczba goli |Awans wskazuje |Drabinka zawiera )/.test(message);
    return new TournamentRepositoryError(isValidationMessage ? message : 'Sprawdź dane turnieju i popraw wskazane pola.', 'INVALID_DOCUMENT');
  }
  return new TournamentRepositoryError(operation === 'load' ? READ_ERROR : SAVE_ERROR, operation === 'load' ? 'LOAD_FAILED' : 'SAVE_UNCONFIRMED');
}

async function request(query, operation, signal) {
  const controller = new AbortController();
  const cancel = () => controller.abort();
  if (signal?.aborted) cancel();
  signal?.addEventListener('abort', cancel, { once: true });
  const timer = setTimeout(cancel, 20000);
  try {
    const { data, error } = await query.abortSignal(controller.signal);
    if (error) throw error;
    return data;
  } catch (error) {
    throw repositoryError(error, operation);
  } finally {
    clearTimeout(timer);
    signal?.removeEventListener('abort', cancel);
  }
}

function fromRecord(record) {
  if (!record || !Number.isInteger(record.revision) || record.revision < 1 || !record.document || record.slug !== record.document.slug) {
    throw new Error('Invalid tournament receipt');
  }
  const document = validateManagedTournament(record.document);
  return { ...document, _revision: record.revision };
}

export async function loadTournamentDocuments({ signal } = {}) {
  try {
    const rows = await request(publicSupabase.from('tournament_documents').select(COLUMNS).order('slug', { ascending: true }), 'load', signal);
    if (!Array.isArray(rows) || new Set(rows.map(row => row.slug)).size !== rows.length) throw new Error('Invalid tournament list');
    return rows.map(fromRecord);
  } catch (error) { throw repositoryError(error, 'load'); }
}

export async function saveTournamentDocument(input, expectedRevision) {
  if (!Number.isInteger(expectedRevision) || expectedRevision < 0 || expectedRevision >= 2147483647) {
    throw new TournamentRepositoryError('Wczytaj aktualne dane turnieju przed zapisem.', 'INVALID_REVISION');
  }
  const { _revision, ...fields } = input || {};
  if (_revision != null && _revision !== expectedRevision) {
    throw new TournamentRepositoryError('Wczytaj aktualne dane turnieju przed zapisem.', 'INVALID_REVISION');
  }
  // Validation errors are already concise Polish guidance for the editor.
  const document = validateManagedTournament(fields);
  try {
    const rows = await request(supabase.rpc('save_tournament_document', {
      p_document: document, p_expected_revision: expectedRevision,
    }), 'save');
    if (!Array.isArray(rows) || rows.length !== 1) throw new Error('Missing tournament receipt');
    const saved = fromRecord(rows[0]);
    if (saved.slug !== document.slug || saved.id !== document.id || saved._revision !== expectedRevision + 1) {
      throw new Error('Mismatched tournament receipt');
    }
    return saved;
  } catch (error) { throw repositoryError(error, 'save'); }
}
