import { CompanyEntity } from 'src/companies/entities/company.entity';
import { TransactionEntity } from 'src/transactions/entities/transaction.entity';
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('benefits')
export class BenefitEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ nullable: true })
  photo: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  cost: number;

  @Column({ default: true })
  active: boolean;

  @ManyToOne('CompanyEntity', 'benefits')
  @JoinColumn({ name: 'company_id' })
  company: CompanyEntity;

  @Column({ name: 'company_id' })
  companyId: string;

  @OneToMany('TransactionEntity', 'benefit')
  transactions: TransactionEntity[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
