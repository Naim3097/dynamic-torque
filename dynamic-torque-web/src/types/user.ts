import type { Tables } from './database';

/** Row shape returned by Supabase `public.users`. */
export type UserRow = Tables<'users'>;

/** UI-facing user shape. Mapped from `UserRow` at the store boundary. */
export interface User {
  id: string;
  email: string;
  fullName: string;
  phone?: string;
  company?: string;
  accountType: 'b2c' | 'b2b';
  isTradeAccount: boolean; // alias of accountType === 'b2b'
  isVerified: boolean;
  createdAt: string;
}

export interface AuthCredentials {
  email: string;
  password: string;
}

export interface RegisterData extends AuthCredentials {
  fullName: string;
  phone?: string;
  company?: string;
}

/** Map a Supabase `users` row into the UI `User` shape. */
export function mapUserRow(row: UserRow): User {
  return {
    id: row.id,
    email: row.email,
    fullName: row.display_name,
    phone: row.phone ?? undefined,
    company: row.business_name ?? undefined,
    accountType: row.account_type === 'b2b' ? 'b2b' : 'b2c',
    isTradeAccount: row.account_type === 'b2b',
    isVerified: row.is_verified,
    createdAt: row.created_at,
  };
}
