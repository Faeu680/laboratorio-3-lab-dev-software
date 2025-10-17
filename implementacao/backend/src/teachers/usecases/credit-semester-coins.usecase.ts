import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TeacherEntity } from '../entities/teacher.entity';
import { TransactionEntity, TransactionTypeEnum } from '../../transactions/entities/transaction.entity';

@Injectable()
export class CreditSemesterCoinsUseCase {
  private readonly SEMESTER_COINS = 1000;

  constructor(
    @InjectRepository(TeacherEntity)
    private readonly teacherRepository: Repository<TeacherEntity>,
    @InjectRepository(TransactionEntity)
    private readonly transactionRepository: Repository<TransactionEntity>,
  ) {}

  async execute(userId: string): Promise<{ balance: number; credited: number }> {
    const teacher = await this.teacherRepository.findOne({
      where: { userId },
    });

    if (!teacher) {
      throw new NotFoundException('Teacher not found');
    }

    // Creditar as moedas
    const newBalance = Number(teacher.balance) + this.SEMESTER_COINS;
    teacher.balance = newBalance;
    teacher.lastCreditDate = new Date();

    await this.teacherRepository.save(teacher);

    // Registrar transação
    const transaction = this.transactionRepository.create({
      type: TransactionTypeEnum.CREDIT,
      amount: this.SEMESTER_COINS,
      teacherId: teacher.id,
      message: 'Crédito semestral de moedas',
    });

    await this.transactionRepository.save(transaction);

    return {
      balance: newBalance,
      credited: this.SEMESTER_COINS,
    };
  }
}
