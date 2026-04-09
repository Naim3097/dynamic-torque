import { create } from 'zustand';
import type { User } from '@/types/user';
import { supabase } from '@/services/supabase';
import {
  fetchProfile,
  signInWithPassword,
  signOut as svcSignOut,
  signUpWithPassword,
  updateProfile as svcUpdateProfile,
} from '@/services/authService';

interface AuthState {
  user: User | null;
  loading: boolean;
  initialized: boolean;
  init: () => Promise<void>;
  isAuthenticated: () => boolean;
  login: (email: string, password: string) => Promise<{ success: boolean; error?: string }>;
  register: (data: {
    fullName: string;
    email: string;
    password: string;
    phone?: string;
    company?: string;
  }) => Promise<{ success: boolean; error?: string; needsConfirmation?: boolean }>;
  logout: () => Promise<void>;
  updateProfile: (data: Partial<Pick<User, 'fullName' | 'phone' | 'company'>>) => Promise<void>;
}

export const useAuthStore = create<AuthState>()((set, get) => ({
  user: null,
  loading: false,
  initialized: false,

  init: async () => {
    if (get().initialized) return;
    set({ loading: true });

    const { data: { session } } = await supabase.auth.getSession();
    if (session?.user) {
      const profile = await fetchProfile(session.user.id);
      set({ user: profile });
    }
    set({ initialized: true, loading: false });

    supabase.auth.onAuthStateChange(async (_event, session) => {
      if (session?.user) {
        const profile = await fetchProfile(session.user.id);
        set({ user: profile });
      } else {
        set({ user: null });
      }
    });
  },

  isAuthenticated: () => get().user !== null,

  login: async (email, password) => {
    set({ loading: true });
    const result = await signInWithPassword(email, password);
    if (result.success === false) {
      set({ loading: false });
      return { success: false, error: result.error };
    }
    // onAuthStateChange will populate the user; also do it eagerly.
    const { data: { user: authUser } } = await supabase.auth.getUser();
    if (authUser) {
      const profile = await fetchProfile(authUser.id);
      set({ user: profile });
    }
    set({ loading: false });
    return { success: true };
  },

  register: async (data) => {
    set({ loading: true });
    const result = await signUpWithPassword(data);
    set({ loading: false });
    if (result.success === false) {
      return { success: false, error: result.error };
    }
    return { success: true, needsConfirmation: result.needsConfirmation };
  },

  logout: async () => {
    await svcSignOut();
    set({ user: null });
  },

  updateProfile: async (patch) => {
    const current = get().user;
    if (!current) return;
    const updated = await svcUpdateProfile(current.id, patch);
    if (updated) set({ user: updated });
  },
}));
