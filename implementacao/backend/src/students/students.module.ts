import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from '../auth/entities/user.entity';
import { InstitutionEntity } from '../institutions/entities/institution.entity';
import { StudentEntity } from './entities/student.entity';
import { StudentsController } from './students.controller';
import { CreateStudentUseCase } from './usecases/create-student.usecase';
import { GetStudentBalanceUseCase } from './usecases/get-student-balance.usecase';

@Module({
  imports: [TypeOrmModule.forFeature([StudentEntity, UserEntity, InstitutionEntity])],
  controllers: [StudentsController],
  providers: [CreateStudentUseCase, GetStudentBalanceUseCase],
  exports: [TypeOrmModule],
})
export class StudentsModule {}
