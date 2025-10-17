import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from '../auth/entities/user.entity';
import { CompaniesController } from './companies.controller';
import { CompanyEntity } from './entities/company.entity';
import { CreateCompanyUseCase } from './usecases/create-company.usecase';

@Module({
  imports: [TypeOrmModule.forFeature([CompanyEntity, UserEntity])],
  controllers: [CompaniesController],
  providers: [CreateCompanyUseCase],
  exports: [TypeOrmModule],
})
export class CompaniesModule {}
