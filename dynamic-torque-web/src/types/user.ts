export interface User {
  id: string;
  email: string;
  fullName: string;
  phone?: string;
  company?: string;
  isTradeAccount: boolean;
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
