import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserEntity } from '../auth/entities/user.entity';
import { InstitutionEntity } from '../institutions/entities/institution.entity';
import { StudentEntity } from './entities/student.entity';
import { StudentsController } from './students.controller';
import { CreateStudentUseCase } from './usecases/create-student.usecase';
import { DeleteStudentUseCase } from './usecases/delete-student.usecase';
import { FindAllStudentsUseCase } from './usecases/find-all-students.usecase';
import { FindStudentByIdUseCase } from './usecases/find-student-by-id.usecase';
import { UpdateStudentUseCase } from './usecases/update-student.usecase';

@Module({
  imports: [TypeOrmModule.forFeature([StudentEntity, UserEntity, InstitutionEntity])],
  controllers: [StudentsController],
  providers: [
    CreateStudentUseCase,
    UpdateStudentUseCase,
    DeleteStudentUseCase,
    FindAllStudentsUseCase,
    FindStudentByIdUseCase,
  ],
  exports: [TypeOrmModule],
})
export class StudentsModule {}
