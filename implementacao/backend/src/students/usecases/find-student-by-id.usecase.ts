import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StudentResponseDto } from '../dto/student-response.dto';
import { StudentEntity } from '../entities/student.entity';

@Injectable()
export class FindStudentByIdUseCase {
  private readonly logger = new Logger(FindStudentByIdUseCase.name);

  constructor(
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>
  ) {}

  async execute(studentId: string): Promise<StudentResponseDto> {
    const student = await this.studentRepository.findOne({
      where: { id: studentId },
      relations: ['user', 'institution'],
    });

    if (!student) {
      throw new NotFoundException('Aluno não encontrado');
    }

    return {
      id: student.id,
      name: student.user.name,
      email: student.user.email,
      cpf: student.cpf,
      rg: student.rg,
      course: student.course,
      balance: Number(student.balance),
      institutionId: student.institutionId,
      institutionName: student.institution?.name,
    };
  }
}
