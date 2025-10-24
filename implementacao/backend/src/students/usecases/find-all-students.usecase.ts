import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StudentResponseDto } from '../dto/student-response.dto';
import { StudentEntity } from '../entities/student.entity';

@Injectable()
export class FindAllStudentsUseCase {
  private readonly logger = new Logger(FindAllStudentsUseCase.name);

  constructor(
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>
  ) {}

  async execute(): Promise<StudentResponseDto[]> {
    const students = await this.studentRepository.find({
      relations: ['user', 'institution'],
      order: { createdAt: 'DESC' },
    });

    return students.map((student) => ({
      id: student.id,
      name: student.user.name,
      email: student.user.email,
      cpf: student.cpf,
      rg: student.rg,
      course: student.course,
      balance: Number(student.balance),
      institutionId: student.institutionId,
      institutionName: student.institution?.name,
    }));
  }
}
