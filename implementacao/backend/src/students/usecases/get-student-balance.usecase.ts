import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StudentBalanceDto } from '../dto/student-balance.dto';
import { StudentEntity } from '../entities/student.entity';

@Injectable()
export class GetStudentBalanceUseCase {
  constructor(
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>,
  ) {}

  async execute(userId: string): Promise<StudentBalanceDto> {
    const student = await this.studentRepository.findOne({
      where: { userId },
      relations: ['user'],
    });

    if (!student) {
      throw new NotFoundException('Student not found');
    }

    return {
      balance: Number(student.balance),
      studentId: student.id,
      name: student.user.name,
      email: student.user.email,
    };
  }
}
