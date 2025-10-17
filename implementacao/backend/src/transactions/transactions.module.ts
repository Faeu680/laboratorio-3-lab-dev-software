import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BenefitEntity } from '../benefits/entities/benefit.entity';
import { StudentEntity } from '../students/entities/student.entity';
import { TeacherEntity } from '../teachers/entities/teacher.entity';
import { TransactionEntity } from './entities/transaction.entity';
import { TransactionsController } from './transactions.controller';
import { GetExtractUseCase } from './usecases/get-extract.usecase';
import { RedeemBenefitUseCase } from './usecases/redeem-benefit.usecase';
import { TransferCoinsUseCase } from './usecases/transfer-coins.usecase';

@Module({
  imports: [TypeOrmModule.forFeature([TransactionEntity, TeacherEntity, StudentEntity, BenefitEntity])],
  controllers: [TransactionsController],
  providers: [TransferCoinsUseCase, RedeemBenefitUseCase, GetExtractUseCase],
  exports: [TypeOrmModule],
})
export class TransactionsModule {}
