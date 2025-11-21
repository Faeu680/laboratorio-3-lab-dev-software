import { CanActivate, ExecutionContext, Injectable, Logger } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Request } from 'express';
import { RolesEnum } from '../consts/roles.enum';
import { ROLES_KEY } from '../decorators/permission-scope.decorator';
import { SKIP_AUTH_KEY } from '../decorators/skip-auth.decorator';

@Injectable()
export class RolesGuard implements CanActivate {
  private logger = new Logger(RolesGuard.name);
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRole = this.reflector.getAllAndOverride<RolesEnum>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    const isPublic = this.reflector.getAllAndOverride<boolean>(SKIP_AUTH_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (isPublic || !requiredRole) {
      return true;
    }

    const request = context.switchToHttp().getRequest() as Request;
    const user = request.user;
    console.log('Validando permissão do usuário', { user, requiredRole });

    return user?.role === requiredRole;
  }
}
