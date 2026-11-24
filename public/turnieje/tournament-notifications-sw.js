/* Local notification preview only: no remote push subscription or page caching. */
self.addEventListener("install", event => event.waitUntil(self.skipWaiting()));
self.addEventListener("activate", event => event.waitUntil(self.clients.claim()));
self.addEventListener("notificationclick", event => {
  event.notification.close();
  // The same file is copied into the unlisted preview directory at build time.
  // Derive the allowed destination from its own scope, never a public alias.
  const scope = new URL(self.registration.scope);
  const basePath = scope.pathname.replace(/\/$/, "");
  const fallback = new URL(`${basePath}/`, scope.origin);
  let target = fallback;
  try {
    const supplied = new URL(event.notification.data?.url || fallback.href, self.location.origin);
    if (supplied.origin === scope.origin && (supplied.pathname === basePath || supplied.pathname.startsWith(`${basePath}/`))) target = supplied;
  } catch { /* Use the tournament list for malformed notification data. */ }
  event.waitUntil((async () => {
    const windows = await self.clients.matchAll({ type: "window", includeUncontrolled: true });
    const samePage = windows.find(client => {
      const current = new URL(client.url);
      return current.origin === target.origin && current.pathname.replace(/\/$/, "") === target.pathname.replace(/\/$/, "");
    });
    if (samePage) return samePage.focus();
    return self.clients.openWindow(target.href);
  })());
});
