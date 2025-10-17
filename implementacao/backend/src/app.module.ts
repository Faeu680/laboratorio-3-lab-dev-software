import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { BenefitsModule } from './benefits/benefits.module';
import { CompaniesModule } from './companies/companies.module';
import { databaseConfig } from './config/database';
import { InstitutionsModule } from './institutions/institutions.module';
import { MailModule } from './mail/mail.module';
import { StudentsModule } from './students/students.module';
import { TeachersModule } from './teachers/teachers.module';
import { TransactionsModule } from './transactions/transactions.module';
import { APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { ResponseInterceptor } from './@shared/interceptors/response.interceptor';
import { HttpExceptionFilter } from './@shared/interceptors/exception-filter';

@Module({
  imports: [
    TypeOrmModule.forRoot(databaseConfig),
    MailModule,
    AuthModule,
    InstitutionsModule,
    StudentsModule,
    TeachersModule,
    CompaniesModule,
    BenefitsModule,
    TransactionsModule,
  ],
  controllers: [],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: ResponseInterceptor,
    },
    {
      provide: APP_FILTER,
      useClass: HttpExceptionFilter,
    },
  ],
})
export class AppModule {}
