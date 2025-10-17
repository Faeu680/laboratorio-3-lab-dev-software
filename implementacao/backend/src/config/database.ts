import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { DataSource, DataSourceOptions } from 'typeorm';
import { env } from './env';

export const databaseConfig: TypeOrmModuleOptions = {
  type: 'postgres',
  url: env.DATABASE_URL,
  entities: ['dist/**/*.entity{.ts,.js}'],
  migrations: ['dist/migrations/*{.ts,.js}'],
  synchronize: false,
  autoLoadEntities: true,
  logging: env.isDev,
  migrationsRun: env.isProd,
};

export const connectionSource = new DataSource(databaseConfig as DataSourceOptions);
