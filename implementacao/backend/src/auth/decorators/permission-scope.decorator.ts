import { SetMetadata } from '@nestjs/common';
import { RolesEnum } from '../consts/roles.enum';

export const ROLES_KEY = 'permission_metadata';
export const Roles = (permission: RolesEnum) => SetMetadata(ROLES_KEY, permission);
