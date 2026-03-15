import React, { createContext, useContext, useEffect, useRef, useState } from 'react';
import { supabase } from '../lib/supabase';
import {
  hasAnyPermission,
  hasGrantedPermissions,
  hasPermission,
  normalizePermissions,
} from '../lib/adminPermissions';

const AuthContext = createContext(null);

function clearStoredAuth() {
  const shouldRemove = (key) => key === 'mlpn-auth' || key.startsWith('sb-');

  Object.keys(localStorage)
    .filter(shouldRemove)
    .forEach((key) => localStorage.removeItem(key));

  Object.keys(sessionStorage)
    .filter(shouldRemove)
    .forEach((key) => sessionStorage.removeItem(key));
}

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
    setLoading(true);

    try {
      const { error } = await supabase.auth.signOut();
      if (error) {
        throw error;
      }
    } catch (err) {
      console.error('signOut error:', err);
    } finally {
      clearStoredAuth();
      setUser(null);
      setProfile(null);
      setLoading(false);
    }
  }

  const isAdmin = profile?.role === 'admin';
  const isEditor = profile?.role === 'editor';
  const isEditorOrAdmin = isAdmin || isEditor;
  const permissions = normalizePermissions(profile?.permissions);
  const accountStatus = profile?.account_status || 'active';
  const isAccountActive = accountStatus === 'active';
  const hasAdminAccess = !!user && isAccountActive && (isAdmin || isEditor || hasGrantedPermissions(permissions));

  const can = (permissionKey) => {
    if (!user || !isAccountActive) return false;
    return hasPermission(permissions, permissionKey, profile?.role || 'viewer');
  };

  const canAny = (permissionKeys) => {
    if (!user || !isAccountActive) return false;
    return hasAnyPermission(permissions, permissionKeys, profile?.role || 'viewer');
  };

  const value = {
    user,
    profile,
    loading,
    permissions,
    accountStatus,
    isAccountActive,
    hasAdminAccess,
    signIn,
    signOut,
    isAdmin,
    isEditor,
    isEditorOrAdmin,
    can,
    canAny,
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
