import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomBytes } from 'crypto';
import { DataSource, Repository } from 'typeorm';
import { BenefitEntity } from '../../benefits/entities/benefit.entity';
import { MailService } from '../../mail/mail.service';
import { StudentEntity } from '../../students/entities/student.entity';
import { RedeemBenefitDto } from '../dto/redeem-benefit.dto';
import { TransactionEntity, TransactionTypeEnum } from '../entities/transaction.entity';

@Injectable()
export class RedeemBenefitUseCase {
  constructor(
    @InjectRepository(TransactionEntity)
    private readonly transactionRepository: Repository<TransactionEntity>,
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>,
    @InjectRepository(BenefitEntity)
    private readonly benefitRepository: Repository<BenefitEntity>,
    private readonly dataSource: DataSource,
    private readonly mailService: MailService,
  ) {}

  async execute(userId: string, dto: RedeemBenefitDto): Promise<TransactionEntity> {
    return this.dataSource.transaction(async (manager) => {
      const student = await manager.findOne(StudentEntity, {
        where: { userId },
        relations: ['user'],
      });

      if (!student) {
        throw new NotFoundException('Student not found');
      }

      const benefit = await manager.findOne(BenefitEntity, {
        where: { id: dto.benefitId, active: true },
        relations: ['company', 'company.user'],
      });

      if (!benefit) {
        throw new NotFoundException('Benefit not found or inactive');
      }

      if (Number(student.balance) < Number(benefit.cost)) {
        throw new BadRequestException('Insufficient balance');
      }

      // Atualizar saldo do aluno
      student.balance = Number(student.balance) - Number(benefit.cost);
      await manager.save(StudentEntity, student);

      // Gerar código do voucher
      const voucherCode = randomBytes(8).toString('hex').toUpperCase();

      // Criar transação
      const transaction = manager.create(TransactionEntity, {
        type: TransactionTypeEnum.REDEMPTION,
        amount: Number(benefit.cost),
        message: `Resgate de vantagem: ${benefit.name}`,
        voucherCode,
        studentId: student.id,
        benefitId: benefit.id,
      });

      const savedTransaction = await manager.save(TransactionEntity, transaction);

      // Enviar email ao aluno com o voucher
      await this.mailService.sendVoucherToStudent({
        recipientEmail: student.user.email,
        recipientName: student.user.name,
        benefitName: benefit.name,
        voucherCode,
        companyName: benefit.company.user.name,
      });

      // Enviar email à empresa parceira
      await this.mailService.sendVoucherToCompany({
        recipientEmail: benefit.company.user.email,
        recipientName: benefit.company.user.name,
        benefitName: benefit.name,
        voucherCode,
        companyName: benefit.company.user.name,
      });

      return savedTransaction;
    });
  }
}
