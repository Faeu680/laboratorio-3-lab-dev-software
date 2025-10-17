import { cleanEnv, port, str, url } from 'envalid';

export const env = cleanEnv(process.env, {
  APP_PORT: port({
    default: 9000,
  }),
  DATABASE_URL: url({
    default: 'postgresql://meritus:meritus@postgres:5432/meritus',
  }),
  JWT_SECRET: str({
    default: '0QruKcexB13BsbqxwgVAwNxsgRSkerI5Sgh7whXMk',
  }),
});
