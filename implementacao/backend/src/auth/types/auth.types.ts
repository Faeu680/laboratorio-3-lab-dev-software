import { RolesEnum } from '../consts/roles.enum';

export interface JwtPayload {
  name: string;
  email: string;
  sub: string;
  iat: number;
  exp: number;
  iss: string;
  aud: string;
  jti: string;
  scope: string;
  role: RolesEnum;
}

export interface AuthUser {
  id: string;
  role: RolesEnum;
  name: string;
  email: string;
}

export interface AuthPayload {
  sub: string;
  email: string;
  role: RolesEnum;
}
