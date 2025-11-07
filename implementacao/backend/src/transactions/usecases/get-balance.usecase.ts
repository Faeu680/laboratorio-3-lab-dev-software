import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { RolesEnum } from 'src/auth/consts/roles.enum';
import { AuthPayload } from 'src/auth/types/auth.types';
import { StudentEntity } from 'src/students/entities/student.entity';
import { TeacherEntity } from 'src/teachers/entities/teacher.entity';
import { Repository } from 'typeorm';
@Injectable()
export class GetBalanceUseCase {
  constructor(
    @InjectRepository(TeacherEntity)
    private readonly teacherRepository: Repository<TeacherEntity>,
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>
  ) {}

  async execute(user: AuthPayload) {
    if (user.role === RolesEnum.STUDENT) return this.getStudentBalance(user.sub);
    if (user.role === RolesEnum.TEACHER) return this.getTeacherBalance(user.sub);

    throw new BadRequestException('Somente estudantes e professores possuem saldo');
  }

  private async getTeacherBalance(userId: string) {
    const teacher = await this.teacherRepository.findOne({
      where: { userId },
      relations: ['user'],
    });

    if (!teacher) {
      throw new NotFoundException('Teacher not found');
    }

    return {
      balance: Number(teacher.balance),
    };
  }

  private async getStudentBalance(userId: string) {
    const student = await this.studentRepository.findOne({
      where: { userId },
      relations: ['user'],
    });

    if (!student) {
      throw new NotFoundException('Student not found');
    }

    return {
      balance: Number(student.balance),
    };
  }
}
