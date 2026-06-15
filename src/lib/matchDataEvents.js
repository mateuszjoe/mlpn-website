export const MATCH_DATA_UPDATED_EVENT = "mlpn:match-data-updated";
export const MATCH_DATA_UPDATED_STORAGE_KEY = "mlpn:match-data-updated-signal";

export function notifyMatchDataUpdated(detail = {}) {
  const payload = {
    ...detail,
    at: Date.now(),
    nonce: Math.random().toString(36).slice(2),
  };

  window.dispatchEvent(new CustomEvent(MATCH_DATA_UPDATED_EVENT, { detail: payload }));

  try {
    window.localStorage?.setItem(MATCH_DATA_UPDATED_STORAGE_KEY, JSON.stringify(payload));
  } catch {
    // Same-tab event is enough when localStorage is unavailable.
  }
}
