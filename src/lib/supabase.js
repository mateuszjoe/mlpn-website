import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL;
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn(
    'Brak zmiennych REACT_APP_SUPABASE_URL lub REACT_APP_SUPABASE_ANON_KEY.\n' +
    'Utwórz plik .env.local z tymi wartościami.'
  );
}

// Klient z autoryzacją (do logowania, operacji admina)
export const supabase = createClient(
  supabaseUrl || '',
  supabaseAnonKey || '',
  {
    auth: {
      storageKey: 'mlpn-auth',
    },
  }
);

// Klient publiczny — zawsze anon key, nigdy nie czeka na refresh tokena.
// Używany do odczytu danych publicznych (tabele, mecze, statystyki).
export const publicSupabase = createClient(
  supabaseUrl || '',
  supabaseAnonKey || '',
  {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
      detectSessionInUrl: false,
      storageKey: 'mlpn-public',
    },
  }
);
