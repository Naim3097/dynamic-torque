// Firebase Cloud Messaging — web push delivery only.
// NO Firebase Auth, Firestore, or Storage.
// Tokens are stored in Supabase `public.fcm_tokens` keyed by the Supabase user ID.

import { initializeApp, type FirebaseApp } from 'firebase/app';
import { getMessaging, getToken, onMessage, type MessagePayload } from 'firebase/messaging';
import { supabase } from './supabase';

let firebaseApp: FirebaseApp | null = null;

function getApp() {
  if (firebaseApp) return firebaseApp;
  const apiKey = import.meta.env.VITE_FIREBASE_API_KEY as string | undefined;
  const projectId = import.meta.env.VITE_FIREBASE_PROJECT_ID as string | undefined;
  const messagingSenderId = import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID as string | undefined;
  const appId = import.meta.env.VITE_FIREBASE_APP_ID as string | undefined;
  if (!apiKey || !projectId || !messagingSenderId || !appId) {
    throw new Error('Firebase messaging env vars missing');
  }
  firebaseApp = initializeApp({ apiKey, projectId, messagingSenderId, appId });
  return firebaseApp;
}

export async function registerPushToken(): Promise<string | null> {
  if (typeof window === 'undefined' || !('Notification' in window)) return null;

  const permission = await Notification.requestPermission();
  if (permission !== 'granted') return null;

  const messaging = getMessaging(getApp());
  const vapidKey = import.meta.env.VITE_FIREBASE_VAPID_KEY as string | undefined;
  if (!vapidKey) {
    console.warn('VITE_FIREBASE_VAPID_KEY missing, cannot register FCM token');
    return null;
  }

  const token = await getToken(messaging, { vapidKey });
  if (!token) return null;

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (user) {
    const { error } = await supabase.from('fcm_tokens').upsert(
      {
        user_id: user.id,
        token,
        platform: 'web',
        user_agent: navigator.userAgent,
        last_seen_at: new Date().toISOString(),
      },
      { onConflict: 'token' }
    );
    if (error) console.error('failed to persist fcm token', error);
  }

  return token;
}

export function onForegroundMessage(cb: (payload: MessagePayload) => void) {
  const messaging = getMessaging(getApp());
  return onMessage(messaging, cb);
}
