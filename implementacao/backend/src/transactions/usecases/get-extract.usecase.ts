import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { RolesEnum } from '../../auth/consts/roles.enum';
import { StudentEntity } from '../../students/entities/student.entity';
import { TeacherEntity } from '../../teachers/entities/teacher.entity';
import { TransactionResponseDto } from '../dto/transaction-response.dto';
import { TransactionEntity, TransactionTypeEnum } from '../entities/transaction.entity';

type TransactionOrigin = 'INCOME' | 'OUTCOME';

interface TransactionQueryConfig {
  where: { studentId?: string; teacherId?: string };
  relations: string[];
}

@Injectable()
export class GetExtractUseCase {
  private readonly STUDENT_RELATIONS = [
    'teacher',
    'teacher.user',
    'benefit',
    'benefit.company',
    'benefit.company.user',
    'student',
    'student.user',
  ];

  private readonly TEACHER_RELATIONS = ['student', 'student.user', 'teacher', 'teacher.user'];

  constructor(
    @InjectRepository(TransactionEntity)
    private readonly transactionRepository: Repository<TransactionEntity>,
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>,
    @InjectRepository(TeacherEntity)
    private readonly teacherRepository: Repository<TeacherEntity>,
  ) {}

  async execute(userId: string, role: RolesEnum): Promise<TransactionResponseDto[]> {
    const transactions = await this.findTransactionsByRole(userId, role);
    return this.mapTransactionsToResponseDto(transactions, userId);
  }

  private async findTransactionsByRole(
    userId: string,
    role: RolesEnum
  ): Promise<TransactionEntity[]> {
    const queryConfig = await this.buildTransactionQuery(userId, role);

    if (!queryConfig) {
      return [];
    }

    return this.transactionRepository.find({
      where: queryConfig.where,
      relations: queryConfig.relations,
      order: { createdAt: 'DESC' },
    });
  }

  private async buildTransactionQuery(
    userId: string,
    role: RolesEnum
  ): Promise<TransactionQueryConfig | null> {
    if (role === RolesEnum.STUDENT) {
      const student = await this.studentRepository.findOne({ where: { userId } });
      if (!student) {
        return null;
      }
      return {
        where: { studentId: student.id },
        relations: this.STUDENT_RELATIONS,
      };
    }

    if (role === RolesEnum.TEACHER) {
      const teacher = await this.teacherRepository.findOne({ where: { userId } });
      if (!teacher) {
        return null;
      }
      return {
        where: { teacherId: teacher.id },
        relations: this.TEACHER_RELATIONS,
      };
    }

    return null;
  }

  private mapTransactionsToResponseDto(
    transactions: TransactionEntity[],
    userId: string
  ): TransactionResponseDto[] {
    return transactions.map((transaction) => this.mapTransactionToDto(transaction, userId));
  }

  private mapTransactionToDto(
    transaction: TransactionEntity,
    userId: string
  ): TransactionResponseDto {
    return {
      id: transaction.id,
      type: transaction.type,
      amount: transaction.amount.toString(),
      message: transaction.message,
      voucherCode: transaction.voucherCode,
      createdAt: transaction.createdAt,
      studentName: transaction.student?.user?.name,
      teacherName: transaction.teacher?.user?.name,
      benefitName: transaction.benefit?.name,
      companyName: transaction.benefit?.company?.user?.name,
      origin: this.calculateTransactionOrigin(transaction, userId),
    };
  }

  private calculateTransactionOrigin(
    transaction: TransactionEntity,
    userId: string
  ): TransactionOrigin {
    if (transaction.type === TransactionTypeEnum.TRANSFER) {
      return transaction.teacher?.userId === userId ? 'OUTCOME' : 'INCOME';
    }

    if (transaction.type === TransactionTypeEnum.REDEMPTION) {
      return 'OUTCOME';
    }

    return 'INCOME';
  }
}
