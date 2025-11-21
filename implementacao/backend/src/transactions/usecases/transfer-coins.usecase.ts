import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { MailService } from '../../mail/mail.service';
import { StudentEntity } from '../../students/entities/student.entity';
import { TeacherEntity } from '../../teachers/entities/teacher.entity';
import { TransferCoinsDto } from '../dto/transfer-coins.dto';
import { TransactionEntity, TransactionTypeEnum } from '../entities/transaction.entity';

@Injectable()
export class TransferCoinsUseCase {
  constructor(
    @InjectRepository(TransactionEntity)
    private readonly transactionRepository: Repository<TransactionEntity>,
    @InjectRepository(TeacherEntity)
    private readonly teacherRepository: Repository<TeacherEntity>,
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>,
    private readonly dataSource: DataSource,
    private readonly mailService: MailService,
  ) {}

  async execute(userId: string, dto: TransferCoinsDto): Promise<TransactionEntity> {
    const amount = parseFloat(dto.amount);
    return this.dataSource.transaction(async (manager) => {
      const teacher = await manager.findOne(TeacherEntity, {
        where: { userId },
        relations: ['user'],
      });

      if (!teacher) {
        throw new NotFoundException('Teacher not found');
      }

      const student = await manager.findOne(StudentEntity, {
        where: { id: dto.studentId },
        relations: ['user'],
      });

      if (!student) {
        throw new NotFoundException('Student not found');
      }

      if (Number(teacher.balance) < amount) {
        throw new BadRequestException('Insufficient balance');
      }

      // Atualizar saldos
      teacher.balance = Number(teacher.balance) - amount;
      student.balance = Number(student.balance) + amount;

      await manager.save(TeacherEntity, teacher);
      await manager.save(StudentEntity, student);

      // Criar transação
      const transaction = manager.create(TransactionEntity, {
        type: TransactionTypeEnum.TRANSFER,
        amount: amount,
        message: dto.message,
        teacherId: teacher.id,
        studentId: student.id,
      });

      const savedTransaction = await manager.save(TransactionEntity, transaction);

      // Enviar email ao aluno
      await this.mailService.sendCoinReceivedEmail({
        studentEmail: student.user.email,
        studentName: student.user.name,
        teacherName: teacher.user.name,
        amount: amount,
        message: dto.message,
      });

      return savedTransaction;
    });
  }
}
