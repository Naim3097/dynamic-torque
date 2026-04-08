import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { User } from '@/types/user';

interface AuthState {
  user: User | null;
  isAuthenticated: () => boolean;
  login: (email: string, password: string) => { success: boolean; error?: string };
  register: (data: { fullName: string; email: string; password: string; phone?: string; company?: string }) => { success: boolean; error?: string };
  logout: () => void;
  updateProfile: (data: Partial<Pick<User, 'fullName' | 'phone' | 'company'>>) => void;
}

// Simple local users store (will be replaced with API)
const USERS_KEY = 'dt-users';

function getStoredUsers(): Array<User & { password: string }> {
  try {
    return JSON.parse(localStorage.getItem(USERS_KEY) || '[]');
  } catch {
    return [];
  }
}

function saveUsers(users: Array<User & { password: string }>) {
  localStorage.setItem(USERS_KEY, JSON.stringify(users));
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,

      isAuthenticated: () => get().user !== null,

      login: (email, password) => {
        const users = getStoredUsers();
        const found = users.find(u => u.email === email && u.password === password);
        if (!found) return { success: false, error: 'Invalid email or password' };
        const { password: _, ...user } = found;
        set({ user });
        return { success: true };
      },

      register: (data) => {
        const users = getStoredUsers();
        if (users.some(u => u.email === data.email)) {
          return { success: false, error: 'Email already registered' };
        }
        const newUser = {
          id: crypto.randomUUID(),
          email: data.email,
          fullName: data.fullName,
          phone: data.phone || '',
          company: data.company || '',
          isTradeAccount: false,
          createdAt: new Date().toISOString(),
          password: data.password,
        };
        saveUsers([...users, newUser]);
        const { password: _, ...user } = newUser;
        set({ user });
        return { success: true };
      },

      logout: () => set({ user: null }),

      updateProfile: (data) => {
        const current = get().user;
        if (!current) return;
        const updated = { ...current, ...data };
        set({ user: updated });
        // Also update in stored users
        const users = getStoredUsers();
        const idx = users.findIndex(u => u.id === current.id);
        if (idx >= 0) {
          users[idx] = { ...users[idx], ...data };
          saveUsers(users);
        }
      },
    }),
    { name: 'dt-auth' }
  )
);
