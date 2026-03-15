import React, { createContext, useContext, useEffect, useRef, useState } from 'react';
import { supabase } from '../lib/supabase';

const AuthContext = createContext(null);

async function fetchProfile(userId) {
  if (!userId) return null;

  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .maybeSingle();

  if (error) {
    console.warn('Profile fetch:', error.message);
    return null;
  }

  return data || null;
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const loadingTimeout = useRef(null);
  const initialized = useRef(false);

  useEffect(() => {
    loadingTimeout.current = setTimeout(() => {
      setLoading(false);
    }, 6000);

    async function initAuth() {
      try {
        const {
          data: { session },
        } = await supabase.auth.getSession();

        if (!session?.user) {
          clearTimeout(loadingTimeout.current);
          setLoading(false);
          initialized.current = true;
          return;
        }

        const { data: refreshed, error: refreshErr } = await supabase.auth.refreshSession();
        const activeSession = !refreshErr && refreshed?.session ? refreshed.session : session;

        setUser(activeSession.user);
        setProfile(await fetchProfile(activeSession.user.id));
      } catch (err) {
        console.error('Auth init error:', err);
      } finally {
        clearTimeout(loadingTimeout.current);
        setLoading(false);
        initialized.current = true;
      }
    }

    initAuth();

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(async (_event, session) => {
      if (!initialized.current) return;

      setLoading(true);
      setUser(session?.user ?? null);

      if (session?.user) {
        setProfile(await fetchProfile(session.user.id));
      } else {
        setProfile(null);
      }

      setLoading(false);
    });

    return () => {
      clearTimeout(loadingTimeout.current);
      subscription.unsubscribe();
    };
  }, []);

  async function signIn(email, password) {
    setLoading(true);

    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) {
      setLoading(false);
      throw error;
    }

    const activeUser = data?.user || data?.session?.user || null;
    if (activeUser) {
      setUser(activeUser);
      setProfile(await fetchProfile(activeUser.id));
    }

    setLoading(false);
    return data;
  }

  async function signOut() {
    try {
      await supabase.auth.signOut();
    } catch (err) {
      console.error('signOut error:', err);
    }

    setUser(null);
    setProfile(null);
    setLoading(false);
  }

  const isAdmin = profile?.role === 'admin';
  const isEditor = profile?.role === 'editor';
  const isEditorOrAdmin = isAdmin || isEditor;

  const value = {
    user,
    profile,
    loading,
    signIn,
    signOut,
    isAdmin,
    isEditor,
    isEditorOrAdmin,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used inside AuthProvider');
  }
  return context;
}
