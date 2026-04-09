import { supabase } from './supabase';
import type { RegisterData, User } from '@/types/user';
import { mapUserRow } from '@/types/user';
import type { TablesUpdate } from '@/types/database';

export type LoginResult =
  | { success: true }
  | { success: false; error: string };

export type RegisterResult =
  | { success: true; needsConfirmation: boolean }
  | { success: false; error: string };

export async function signInWithPassword(
  email: string,
  password: string
): Promise<LoginResult> {
  const { error } = await supabase.auth.signInWithPassword({ email, password });
  if (error) return { success: false, error: error.message };
  return { success: true };
}

export async function signUpWithPassword(
  data: RegisterData
): Promise<RegisterResult> {
  const { data: res, error } = await supabase.auth.signUp({
    email: data.email,
    password: data.password,
    options: {
      data: {
        display_name: data.fullName,
        phone: data.phone ?? '',
        business_name: data.company ?? '',
      },
    },
  });
  if (error) return { success: false, error: error.message };

  // If `Confirm email` is on, the API returns a user but no session.
  const needsConfirmation = res.session === null;

  // Fill extra profile fields the auth trigger doesn't know about.
  // When confirmation is on, this runs only after the user logs in later —
  // so we best-effort attempt it now and ignore the RLS rejection if needed.
  if (res.user && !needsConfirmation) {
    await supabase
      .from('users')
      .update({
        display_name: data.fullName,
        phone: data.phone ?? null,
        business_name: data.company ?? null,
      })
      .eq('id', res.user.id);
  }

  return { success: true, needsConfirmation };
}

export async function signOut(): Promise<void> {
  await supabase.auth.signOut();
}

export async function fetchProfile(userId: string): Promise<User | null> {
  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('id', userId)
    .maybeSingle();
  if (error || !data) return null;
  return mapUserRow(data);
}

export async function updateProfile(
  userId: string,
  patch: { fullName?: string; phone?: string; company?: string }
): Promise<User | null> {
  const dbPatch: TablesUpdate<'users'> = {};
  if (patch.fullName !== undefined) dbPatch.display_name = patch.fullName;
  if (patch.phone !== undefined) dbPatch.phone = patch.phone || null;
  if (patch.company !== undefined) dbPatch.business_name = patch.company || null;

  const { data, error } = await supabase
    .from('users')
    .update(dbPatch)
    .eq('id', userId)
    .select('*')
    .maybeSingle();
  if (error || !data) return null;
  return mapUserRow(data);
}
