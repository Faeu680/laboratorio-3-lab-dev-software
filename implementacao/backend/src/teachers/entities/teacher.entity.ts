import { UserEntity } from 'src/auth/entities/user.entity';
import { InstitutionEntity } from 'src/institutions/entities/institution.entity';
import { TransactionEntity } from 'src/transactions/entities/transaction.entity';
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('teachers')
export class TeacherEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  cpf: string;

  @Column()
  department: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  balance: number;

  @Column({ name: 'last_credit_date', type: 'timestamp', nullable: true })
  lastCreditDate: Date;

  @ManyToOne('InstitutionEntity', 'teachers')
  @JoinColumn({ name: 'institution_id' })
  institution: InstitutionEntity;

  @Column({ name: 'institution_id' })
  institutionId: string;

  @OneToOne('UserEntity')
  @JoinColumn({ name: 'user_id' })
  user: UserEntity;

  @Column({ name: 'user_id' })
  userId: string;

  @OneToMany('TransactionEntity', 'teacher')
  transactions: TransactionEntity[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
