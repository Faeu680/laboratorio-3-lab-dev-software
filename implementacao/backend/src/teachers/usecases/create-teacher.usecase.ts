import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import bcrypt from 'bcrypt';
import { Repository } from 'typeorm';
import { UserEntity } from '../../auth/entities/user.entity';
import { RolesEnum } from '../../auth/consts/roles.enum';
import { InstitutionEntity } from '../../institutions/entities/institution.entity';
import { CreateTeacherDto } from '../dto/create-teacher.dto';
import { TeacherEntity } from '../entities/teacher.entity';

@Injectable()
export class CreateTeacherUseCase {
  constructor(
    @InjectRepository(TeacherEntity)
    private readonly teacherRepository: Repository<TeacherEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    @InjectRepository(InstitutionEntity)
    private readonly institutionRepository: Repository<InstitutionEntity>,
  ) {}

  async execute(dto: CreateTeacherDto): Promise<TeacherEntity> {
    const existingUser = await this.userRepository.findOne({ where: { email: dto.email } });
    if (existingUser) {
      throw new ConflictException('User already exists');
    }

    const institution = await this.institutionRepository.findOne({
      where: { id: dto.institutionId },
    });
    if (!institution) {
      throw new NotFoundException('Institution not found');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);

    const user = this.userRepository.create({
      email: dto.email,
      password: hashedPassword,
      name: dto.name,
      role: RolesEnum.TEACHER,
      address: dto.address,
    });

    await this.userRepository.save(user);

    const teacher = this.teacherRepository.create({
      cpf: dto.cpf,
      department: dto.department,
      institutionId: dto.institutionId,
      userId: user.id,
      balance: 0,
    });

    return this.teacherRepository.save(teacher);
  }
}
