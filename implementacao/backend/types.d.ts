import { AuthUser } from 'src/auth/types/auth.types';

declare module 'express' {
  interface Request {
    user?: AuthUser;
  }
}
