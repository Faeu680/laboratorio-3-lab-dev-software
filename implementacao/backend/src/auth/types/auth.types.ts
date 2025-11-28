import { RolesEnum } from '../consts/roles.enum';
export interface Profile {
  id: string;
  cpf: string; // formato "000.000.000-00"
  department?: string | null;
  balance: string; // valor monetário em string (ex: "1900.00")
  lastCreditDate?: string | null; // ISO string
  institutionId?: string | null;
  userId?: string | null;
  createdAt?: string | null; // ISO string
  updatedAt?: string | null; // ISO string
}

export interface JwtPayload {
  sub: string;
  profile: Profile;
  id: string;
  email: string;
  name: string;
  role: RolesEnum;
  address?: string | null;
  iat: number; // epoch seconds
  exp: number; // epoch seconds
}
export interface AuthUser {
  id: string;
  role: RolesEnum;
  profileId: string;
  name: string;
  email: string;
  institutionId?: string;
}
