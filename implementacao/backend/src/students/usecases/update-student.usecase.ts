import {
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserEntity } from 'src/auth/entities/user.entity';
import { Repository } from 'typeorm';
import { UpdateStudentDto } from '../dto/update-student.dto';
import { StudentResponseDto } from '../dto/student-response.dto';
import { StudentEntity } from '../entities/student.entity';

@Injectable()
export class UpdateStudentUseCase {
  private readonly logger = new Logger(UpdateStudentUseCase.name);

  constructor(
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>
  ) {}

  async execute(
    studentId: string,
    dto: UpdateStudentDto
  ): Promise<StudentResponseDto> {
    const student = await this.studentRepository.findOne({
      where: { id: studentId },
      relations: ['user', 'institution'],
    });

    if (!student) {
      throw new NotFoundException('Aluno não encontrado');
    }

    // Verificar se o email já existe em outro usuário
    if (dto.email && dto.email !== student.user.email) {
      const existingUser = await this.userRepository.findOne({
        where: { email: dto.email },
      });

      if (existingUser) {
        throw new ConflictException('Email já está em uso');
      }
    }

    // Atualizar dados do usuário
    if (dto.name || dto.email) {
      await this.userRepository.update(student.userId, {
        name: dto.name || student.user.name,
        email: dto.email || student.user.email,
      });
    }

    // Atualizar dados do estudante
    await this.studentRepository.update(studentId, {
      cpf: dto.cpf || student.cpf,
      rg: dto.rg || student.rg,
      course: dto.course || student.course,
    });

    const updatedStudent = await this.studentRepository.findOne({
      where: { id: studentId },
      relations: ['user', 'institution'],
    });

    this.logger.log(`Aluno atualizado: ${updatedStudent.user.name}`);

    return {
      id: updatedStudent.id,
      name: updatedStudent.user.name,
      email: updatedStudent.user.email,
      cpf: updatedStudent.cpf,
      rg: updatedStudent.rg,
      course: updatedStudent.course,
      balance: Number(updatedStudent.balance),
      institutionId: updatedStudent.institutionId,
      institutionName: updatedStudent.institution?.name,
    };
  }
}
