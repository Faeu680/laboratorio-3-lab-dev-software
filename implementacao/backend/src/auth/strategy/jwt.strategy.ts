import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy as BaseStrategy, ExtractJwt } from 'passport-jwt';
import { env } from '../../config/env';
import { AuthUser, JwtPayload } from '../types/auth.types';

@Injectable()
export class JwtStrategy extends PassportStrategy(BaseStrategy) {
  constructor() {
    super({
      secretOrKey: env.JWT_SECRET,
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      algorithms: ['RS256'],
    });
  }

  async validate(payload: JwtPayload): Promise<AuthUser> {
    return {
      id: payload.sub,
      name: payload.name,
      email: payload.email,
      role: payload.role,
    };
  }
}
