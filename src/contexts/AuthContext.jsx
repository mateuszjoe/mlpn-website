import React, { createContext, useContext, useEffect, useRef, useState } from 'react';
import { supabase } from '../lib/supabase';
import {
  hasAnyPermission,
  hasGrantedPermissions,
  hasPermission,
  normalizePermissions,
} from '../lib/adminPermissions';

const AuthContext = createContext(null);
const AUTH_TIMEOUT_MS = 8000;
const POST_LOGIN_ROUTE_KEY = 'mlpn:post-login-route';

function storePostLoginRoute(route) {
  if (!route || typeof window === 'undefined') return;

  try {
    window.localStorage?.setItem(POST_LOGIN_ROUTE_KEY, route);
  } catch {
    // Brak dostepu do localStorage nie blokuje logowania.
  }
}

function applyStoredPostLoginRoute() {
  if (typeof window === 'undefined') return;

  try {
    const route = window.localStorage?.getItem(POST_LOGIN_ROUTE_KEY);
    if (!route) return;

    window.localStorage.removeItem(POST_LOGIN_ROUTE_KEY);
    window.setTimeout(() => {
      const targetUrl = route.startsWith('#')
        ? `${window.location.origin}/${route}`
        : new URL(route, window.location.origin).toString();

      window.history.replaceState(
        window.history.state && typeof window.history.state === 'object'
          ? { ...window.history.state }
          : {},
        '',
        targetUrl
      );
      window.dispatchEvent(new Event('popstate'));
      window.dispatchEvent(new Event('hashchange'));
    }, 0);
  } catch {
    // Nawigacja po logowaniu jest wygoda, nie warunkiem dzialania sesji.
  }
}

function getOAuthCallbackParams() {
  if (typeof window === 'undefined') return null;

  const params = new URLSearchParams(window.location.search || '');
  const code = params.get('code');
  const error = params.get('error_description') || params.get('error');

  if (!code && !error) return null;
  return { code, error };
}

async function getInitialSession() {
  const callbackParams = getOAuthCallbackParams();

  if (callbackParams?.error) {
    throw new Error(callbackParams.error);
  }

  if (callbackParams?.code) {
    const { data, error } = await withTimeout(
      supabase.auth.exchangeCodeForSession(callbackParams.code),
      AUTH_TIMEOUT_MS,
      'OAuth callback'
    );

    if (error) {
      throw error;
    }

    return data?.session ?? null;
  }

  const sessionResponse = await withTimeout(supabase.auth.getSession(), AUTH_TIMEOUT_MS, 'auth session');
  return sessionResponse?.data?.session ?? null;
}

function clearOAuthCallbackUrl() {
  if (typeof window === 'undefined' || !getOAuthCallbackParams()) return;

  try {
    window.history.replaceState(
      window.history.state && typeof window.history.state === 'object'
        ? { ...window.history.state }
        : {},
      '',
      `${window.location.origin}/`
    );
  } catch {
    // Czyszczenie URL nie moze blokowac auth.
  }
}

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

function withTimeout(promise, timeoutMs, label) {
  let timeoutId;

  return Promise.race([
    promise,
    new Promise((_, reject) => {
      timeoutId = window.setTimeout(() => {
        reject(new Error(`${label} timeout`));
      }, timeoutMs);
    }),
  ]).finally(() => {
    if (timeoutId) {
      window.clearTimeout(timeoutId);
    }
  });
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [profile, setProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const loadingTimeout = useRef(null);
  const initialized = useRef(false);
  const isMounted = useRef(true);
  const syncRequestId = useRef(0);

  const stopLoading = () => {
    if (loadingTimeout.current) {
      window.clearTimeout(loadingTimeout.current);
      loadingTimeout.current = null;
    }
    if (isMounted.current) {
      setLoading(false);
    }
  };

  const startLoadingGuard = () => {
    if (loadingTimeout.current) {
      window.clearTimeout(loadingTimeout.current);
    }

    loadingTimeout.current = window.setTimeout(() => {
      if (isMounted.current) {
        setLoading(false);
      }
    }, AUTH_TIMEOUT_MS);
  };

  const syncSessionState = async (session, { blockUi = false, resetProfile = false } = {}) => {
    const requestId = ++syncRequestId.current;

    if (blockUi && isMounted.current) {
      setLoading(true);
      startLoadingGuard();
    }

    if (!session?.user) {
      if (!isMounted.current || syncRequestId.current !== requestId) return;
      setUser(null);
      setProfile(null);
      if (blockUi) stopLoading();
      return;
    }

    if (isMounted.current) {
      setUser(session.user);
      if (resetProfile) {
        setProfile((current) => (current?.id === session.user.id ? current : null));
      }
    }

    try {
      const nextProfile = await withTimeout(fetchProfile(session.user.id), AUTH_TIMEOUT_MS, 'profile fetch');
      if (!isMounted.current || syncRequestId.current !== requestId) return;
      setProfile(nextProfile);
    } catch (err) {
      console.error('Profile sync error:', err);
      if (!isMounted.current || syncRequestId.current !== requestId) return;
      setProfile((current) => (current?.id === session.user.id ? current : null));
    } finally {
      applyStoredPostLoginRoute();
      if (blockUi) {
        stopLoading();
      }
    }
  };

  useEffect(() => {
    isMounted.current = true;
    startLoadingGuard();

    async function initAuth() {
      try {
        const session = await getInitialSession();
        await syncSessionState(session, {
          blockUi: true,
          resetProfile: true,
        });
      } catch (err) {
        console.error('Auth init error:', err);
        if (isMounted.current) {
          setUser(null);
          setProfile(null);
        }
        applyStoredPostLoginRoute();
      } finally {
        clearOAuthCallbackUrl();
        stopLoading();
        initialized.current = true;
      }
    }

    initAuth();

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      if (!initialized.current) return;
      syncSessionState(session, { blockUi: false, resetProfile: false });
    });

    return () => {
      isMounted.current = false;
      stopLoading();
      subscription.unsubscribe();
    };
  }, []);

  async function signIn(email, password) {
    setLoading(true);
    startLoadingGuard();

    try {
      const { data, error } = await withTimeout(
        supabase.auth.signInWithPassword({ email, password }),
        AUTH_TIMEOUT_MS,
        'sign in'
      );
      if (error) {
        throw error;
      }

      const activeSession = data?.session || (data?.user ? { user: data.user } : null);
      await syncSessionState(activeSession, { blockUi: false, resetProfile: true });

      stopLoading();
      return data;
    } catch (error) {
      stopLoading();
      throw error;
    }
  }

  async function signInWithProvider(provider, { next = '#/typer' } = {}) {
    setLoading(true);
    startLoadingGuard();

    try {
      storePostLoginRoute(next);
      const { data, error } = await withTimeout(
        supabase.auth.signInWithOAuth({
          provider,
          options: {
            redirectTo: `${window.location.origin}/auth/callback`,
          },
        }),
        AUTH_TIMEOUT_MS,
        `${provider} sign in`
      );

      if (error) {
        throw error;
      }

      return data;
    } catch (error) {
      stopLoading();
      throw error;
    }
  }

  async function signOut() {
    setLoading(true);
    startLoadingGuard();

    try {
      const { error } = await withTimeout(supabase.auth.signOut(), AUTH_TIMEOUT_MS, 'sign out');
      if (error) {
        throw error;
      }
    } catch (err) {
      console.error('signOut error:', err);
    } finally {
      clearStoredAuth();
      setUser(null);
      setProfile(null);
      stopLoading();
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
    signInWithProvider,
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
