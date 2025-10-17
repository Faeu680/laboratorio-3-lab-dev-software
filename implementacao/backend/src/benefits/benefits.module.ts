import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CompanyEntity } from '../companies/entities/company.entity';
import { BenefitsController } from './benefits.controller';
import { BenefitEntity } from './entities/benefit.entity';
import { CreateBenefitUseCase } from './usecases/create-benefit.usecase';
import { ListBenefitsUseCase } from './usecases/list-benefits.usecase';

@Module({
  imports: [TypeOrmModule.forFeature([BenefitEntity, CompanyEntity])],
  controllers: [BenefitsController],
  providers: [CreateBenefitUseCase, ListBenefitsUseCase],
  exports: [TypeOrmModule],
})
export class BenefitsModule {}
