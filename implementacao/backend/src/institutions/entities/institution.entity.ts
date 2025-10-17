import { StudentEntity } from 'src/students/entities/student.entity';
import { TeacherEntity } from 'src/teachers/entities/teacher.entity';
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';

@Entity('institutions')
export class InstitutionEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  address: string;

  @Column()
  email: string;

  @Column({ nullable: true })
  phone: string;

  @OneToMany('StudentEntity', 'institution')
  students: StudentEntity[];

  @OneToMany('TeacherEntity', 'institution')
  teachers: TeacherEntity[];
}
