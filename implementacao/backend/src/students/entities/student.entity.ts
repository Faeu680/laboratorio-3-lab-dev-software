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

@Entity('students')
export class StudentEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  cpf: string;

  @Column()
  rg: string;

  @Column()
  course: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  balance: number;

  @ManyToOne('InstitutionEntity', 'students')
  @JoinColumn({ name: 'institution_id' })
  institution: InstitutionEntity;

  @Column({ name: 'institution_id' })
  institutionId: string;

  @OneToOne('UserEntity')
  @JoinColumn({ name: 'user_id' })
  user: UserEntity;

  @Column({ name: 'user_id' })
  userId: string;

  @OneToMany('TransactionEntity', 'student')
  transactions: TransactionEntity[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
