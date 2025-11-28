import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CompanyEntity } from '../companies/entities/company.entity';
import { BenefitsController } from './benefits.controller';
import { BenefitEntity } from './entities/benefit.entity';
import { CreateBenefitUseCase } from './usecases/create-benefit.usecase';
import { ListBenefitsUseCase } from './usecases/list-benefits.usecase';
import { UploadModule } from 'src/upload/upload.module';
import { TransactionEntity } from 'src/transactions/entities/transaction.entity';
import { ListMyBenefitsUseCase } from './usecases/list-my-benefits.usecase';

@Module({
  imports: [
    TypeOrmModule.forFeature([BenefitEntity, CompanyEntity, TransactionEntity]),
    UploadModule,
  ],
  controllers: [BenefitsController],
  providers: [CreateBenefitUseCase, ListBenefitsUseCase, ListMyBenefitsUseCase],
  exports: [TypeOrmModule],
})
export class BenefitsModule {}
