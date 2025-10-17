import { BenefitEntity } from 'src/benefits/entities/benefit.entity';
import { StudentEntity } from 'src/students/entities/student.entity';
import { TeacherEntity } from 'src/teachers/entities/teacher.entity';
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';

export enum TransactionTypeEnum {
  TRANSFER = 'TRANSFER', // Professor -> Aluno
  REDEMPTION = 'REDEMPTION', // Aluno -> Benefit
  CREDIT = 'CREDIT', // Sistema -> Professor (crédito semestral)
}

@Entity('transactions')
export class TransactionEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'enum', enum: TransactionTypeEnum })
  type: TransactionTypeEnum;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  amount: number;

  @Column({ type: 'text', nullable: true })
  message: string;

  @Column({ nullable: true, name: 'voucher_code' })
  voucherCode: string;

  @ManyToOne('StudentEntity', 'transactions', { nullable: true })
  @JoinColumn({ name: 'student_id' })
  student: StudentEntity;

  @Column({ name: 'student_id', nullable: true })
  studentId: string;

  @ManyToOne('TeacherEntity', 'transactions', { nullable: true })
  @JoinColumn({ name: 'teacher_id' })
  teacher: TeacherEntity;

  @Column({ name: 'teacher_id', nullable: true })
  teacherId: string;

  @ManyToOne('BenefitEntity', 'transactions', { nullable: true })
  @JoinColumn({ name: 'benefit_id' })
  benefit: BenefitEntity;

  @Column({ name: 'benefit_id', nullable: true })
  benefitId: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}
