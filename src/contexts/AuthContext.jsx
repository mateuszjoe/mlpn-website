import React, { createContext, useContext, useState, useEffect, useRef } from 'react';
import { supabase } from '../lib/supabase';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const loadingTimeout = useRef(null);
  const initialized = useRef(false);

  useEffect(() => {
    // Timeout bezpieczeństwa
    loadingTimeout.current = setTimeout(() => {
      setLoading(false);
    }, 6000);

    async function initAuth() {
      try {
        const { data: { session } } = await supabase.auth.getSession();

        if (!session?.user) {
          clearTimeout(loadingTimeout.current);
          setLoading(false);
          initialized.current = true;
          return;
        }

        // Wymuś odświeżenie tokenu JWT
        const { data: refreshed, error: refreshErr } = await supabase.auth.refreshSession();
        const activeSession = (!refreshErr && refreshed?.session) ? refreshed.session : session;

        setUser(activeSession.user);

        // Pobierz profil z odświeżonym tokenem
        const { data, error } = await supabase
          .from('profiles')
          .select('*')
          .eq('id', activeSession.user.id)
          .single();

        if (!error && data) {
          setProfile(data);
        } else {
          console.warn('Profil init:', error?.message);
          setProfile(null);
        }
      } catch (err) {
        console.error('Auth init error:', err);
      } finally {
        clearTimeout(loadingTimeout.current);
        setLoading(false);
        initialized.current = true;
      }
    }

    initAuth();

    // Nasłuchuj PRZYSZŁYCH zmian auth (logowanie, wylogowanie)
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        // Ignoruj zdarzenia przed zakończeniem inicjalizacji — zapobiega race condition
        if (!initialized.current) return;

        setUser(session?.user ?? null);
        if (session?.user) {
          const { data } = await supabase
            .from('profiles')
            .select('*')
            .eq('id', session.user.id)
            .single();
          setProfile(data || null);
        } else {
          setProfile(null);
        }
        setLoading(false);
      }
    );

    return () => {
      clearTimeout(loadingTimeout.current);
      subscription.unsubscribe();
    };
  }, []);

  async function signIn(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) throw error;
    return data;
  }

  async function signOut() {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      console.error('signOut error:', e);
    }
    setUser(null);
    setProfile(null);
  }

  const isAdmin = profile?.role === 'admin';
  const isEditor = profile?.role === 'editor';
  const isEditorOrAdmin = isAdmin || isEditor;

  const value = {
    user, profile, loading, signIn, signOut,
    isAdmin, isEditor, isEditorOrAdmin,
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth musi być używany wewnątrz AuthProvider');
  }
  return context;
}
