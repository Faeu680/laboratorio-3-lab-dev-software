import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TeacherBalanceDto } from '../dto/teacher-balance.dto';
import { TeacherEntity } from '../entities/teacher.entity';

@Injectable()
export class GetTeacherBalanceUseCase {
  constructor(
    @InjectRepository(TeacherEntity)
    private readonly teacherRepository: Repository<TeacherEntity>,
  ) {}

  async execute(userId: string): Promise<TeacherBalanceDto> {
    const teacher = await this.teacherRepository.findOne({
      where: { userId },
      relations: ['user'],
    });

    if (!teacher) {
      throw new NotFoundException('Teacher not found');
    }

    return {
      balance: Number(teacher.balance),
      teacherId: teacher.id,
      name: teacher.user.name,
      email: teacher.user.email,
      lastCreditDate: teacher.lastCreditDate,
    };
  }
}
