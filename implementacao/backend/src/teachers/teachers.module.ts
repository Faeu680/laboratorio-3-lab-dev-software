import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from '../auth/entities/user.entity';
import { InstitutionEntity } from '../institutions/entities/institution.entity';
import { TransactionEntity } from '../transactions/entities/transaction.entity';
import { TeacherEntity } from './entities/teacher.entity';
import { TeachersController } from './teachers.controller';
import { CreateTeacherUseCase } from './usecases/create-teacher.usecase';
import { CreditSemesterCoinsUseCase } from './usecases/credit-semester-coins.usecase';

@Module({
  imports: [
    TypeOrmModule.forFeature([TeacherEntity, UserEntity, InstitutionEntity, TransactionEntity]),
  ],
  controllers: [TeachersController],
  providers: [CreateTeacherUseCase, CreditSemesterCoinsUseCase],
  exports: [TypeOrmModule],
})
export class TeachersModule {}
