import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { StudentEntity } from '../entities/student.entity';
import { UserEntity } from 'src/auth/entities/user.entity';

@Injectable()
export class DeleteStudentUseCase {
  private readonly logger = new Logger(DeleteStudentUseCase.name);

  constructor(
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>,
    private readonly dataSource: DataSource
  ) {}

  async execute(studentId: string): Promise<void> {
    const student = await this.studentRepository.findOne({
      where: { id: studentId },
      relations: ['user'],
    });

    if (!student) {
      throw new NotFoundException('Aluno não encontrado');
    }

    // Usar transação para garantir que ambos sejam deletados
    await this.dataSource.transaction(async (manager) => {
      await manager.delete(StudentEntity, studentId);
      await manager.delete(UserEntity, student.userId);
    });

    this.logger.log(`Aluno deletado: ${student.user.name} (${studentId})`);
  }
}
