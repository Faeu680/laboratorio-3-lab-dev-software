import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { RolesEnum } from '../../auth/consts/roles.enum';
import { StudentEntity } from '../../students/entities/student.entity';
import { TeacherEntity } from '../../teachers/entities/teacher.entity';
import { TransactionResponseDto } from '../dto/transaction-response.dto';
import { TransactionEntity, TransactionTypeEnum } from '../entities/transaction.entity';

enum TransactionCalculatedType {
  INCOME = "INCOME",
  OUTCOME = "OUTCOME"
}

@Injectable()
export class GetExtractUseCase {
  constructor(
    @InjectRepository(TransactionEntity)
    private readonly transactionRepository: Repository<TransactionEntity>,
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>,
    @InjectRepository(TeacherEntity)
    private readonly teacherRepository: Repository<TeacherEntity>,
  ) {}

  async execute(userId: string, role: RolesEnum): Promise<TransactionResponseDto[]> {
    let transactions: TransactionEntity[] = [];

    if (role === RolesEnum.STUDENT) {
      const student = await this.studentRepository.findOne({ where: { userId } });
      if (student) {
        transactions = await this.transactionRepository.find({
          where: { studentId: student.id },
          relations: ['teacher', 'teacher.user', 'benefit', 'benefit.company', 'benefit.company.user', 'student', 'student.user'],
          order: { createdAt: 'DESC' },
        });
      }
    } else if (role === RolesEnum.TEACHER) {
      const teacher = await this.teacherRepository.findOne({ where: { userId } });
      if (teacher) {
        transactions = await this.transactionRepository.find({
          where: { teacherId: teacher.id },
          relations: ['student', 'student.user', 'teacher', 'teacher.user'],
          order: { createdAt: 'DESC' },
        });
      }
    }

    return transactions.map((t) => ({
      id: t.id,
      type: t.type,
      amount: t.amount.toString(),
      message: t.message,
      voucherCode: t.voucherCode,
      createdAt: t.createdAt,
      studentName: t.student?.user?.name,
      teacherName: t.teacher?.user?.name,
      benefitName: t.benefit?.name,
      companyName: t.benefit?.company?.user?.name,
      origin: this.calculateTransactionType(t, userId),
    }));
  }

  private calculateTransactionType(transaction: TransactionEntity, userId: string): TransactionCalculatedType {
    if (transaction.type === TransactionTypeEnum.TRANSFER) {
      if (transaction.teacher.userId === userId) {
        return TransactionCalculatedType.OUTCOME;
      }

      if (transaction.student.userId === userId) {
        return TransactionCalculatedType.INCOME;
      }
    }

    if (transaction.type === TransactionTypeEnum.REDEMPTION) {
      return TransactionCalculatedType.OUTCOME;
    }

    return TransactionCalculatedType.INCOME;
  }
}
