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
  S3_ENDPOINT: str({
    default: '',
  }),
  S3_ACCESS_KEY_ID: str({}),
  S3_SECRET_ACCESS_KEY: str({}),
  S3_BUCKET: str({}),
  RESEND_API_KEY: str({}),
  MAIL_FROM: str({
    default: 'onboarding@resend.dev',
  }),
});
