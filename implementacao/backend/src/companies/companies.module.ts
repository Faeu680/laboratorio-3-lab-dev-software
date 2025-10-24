import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from '../auth/entities/user.entity';
import { CompaniesController } from './companies.controller';
import { CompanyEntity } from './entities/company.entity';
import { CreateCompanyUseCase } from './usecases/create-company.usecase';
import { DeleteCompanyUseCase } from './usecases/delete-company.usecase';
import { FindAllCompaniesUseCase } from './usecases/find-all-companies.usecase';
import { FindCompanyByIdUseCase } from './usecases/find-company-by-id.usecase';
import { UpdateCompanyUseCase } from './usecases/update-company.usecase';

@Module({
  imports: [TypeOrmModule.forFeature([CompanyEntity, UserEntity])],
  controllers: [CompaniesController],
  providers: [
    CreateCompanyUseCase,
    UpdateCompanyUseCase,
    DeleteCompanyUseCase,
    FindAllCompaniesUseCase,
    FindCompanyByIdUseCase,
  ],
  exports: [TypeOrmModule],
})
export class CompaniesModule {}
