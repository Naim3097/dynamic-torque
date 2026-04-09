import { defineConfig, type Plugin } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import { writeFileSync, mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

/**
 * Vite plugin that generates firebase-messaging-sw.js with env vars injected.
 * During build the file is written to the output directory.
 * During dev it is served via middleware so it appears at the site root.
 */
function firebaseServiceWorkerPlugin(): Plugin {
  function generateSW(env: Record<string, string>): string {
    return `// Auto-generated — do not edit manually.
// Firebase Cloud Messaging service worker — handles push notifications
// delivered to the browser while the app is in the background.

/* eslint-disable no-undef */

importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: ${JSON.stringify(env['VITE_FIREBASE_API_KEY'] || '')},
  projectId: ${JSON.stringify(env['VITE_FIREBASE_PROJECT_ID'] || '')},
  messagingSenderId: ${JSON.stringify(env['VITE_FIREBASE_MESSAGING_SENDER_ID'] || '')},
  appId: ${JSON.stringify(env['VITE_FIREBASE_APP_ID'] || '')},
});

var messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
  var notification = payload.notification;
  var data = payload.data;
  if (!notification) return;

  self.registration.showNotification(notification.title || 'Dynamic Torque', {
    body: notification.body || '',
    icon: '/favicon.ico',
    badge: '/favicon.ico',
    data: data || {},
  });
});

self.addEventListener('notificationclick', function (event) {
  event.notification.close();
  var url = (event.notification.data && event.notification.data.url) || '/';
  event.waitUntil(
    self.clients.matchAll({ type: 'window' }).then(function (clients) {
      for (var i = 0; i < clients.length; i++) {
        if ('focus' in clients[i]) {
          clients[i].navigate(url);
          return clients[i].focus();
        }
      }
      if (self.clients.openWindow) return self.clients.openWindow(url);
    })
  );
});
`
  }

  let resolvedEnv: Record<string, string> = {}

  return {
    name: 'firebase-sw-generator',
    configResolved(config) {
      // Collect all VITE_ env vars from the resolved config
      const raw = config.env ?? {}
      resolvedEnv = { ...raw }
    },
    // Dev: serve the generated SW via middleware
    configureServer(server) {
      server.middlewares.use((req, res, next) => {
        if (req.url === '/firebase-messaging-sw.js') {
          res.setHeader('Content-Type', 'application/javascript')
          res.end(generateSW(resolvedEnv))
          return
        }
        next()
      })
    },
    // Build: write the file to the output directory
    closeBundle() {
      const outDir = resolve(process.cwd(), 'dist')
      mkdirSync(outDir, { recursive: true })
      writeFileSync(resolve(outDir, 'firebase-messaging-sw.js'), generateSW(resolvedEnv))
    },
  }
}

export default defineConfig({
  plugins: [react(), tailwindcss(), firebaseServiceWorkerPlugin()],
  resolve: {
    alias: {
      '@': '/src',
    },
  },
  server: {
    port: 3000,
  },
})
