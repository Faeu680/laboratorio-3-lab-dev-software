import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import bcrypt from 'bcrypt';
import { plainToClass } from 'class-transformer';
import { Repository } from 'typeorm';
import { SignInResponseDto } from '../../auth/dto/signin-response.dto';
import { UserEntity } from '../../auth/entities/user.entity';
import { RolesEnum } from '../../auth/consts/roles.enum';
import { InstitutionEntity } from '../../institutions/entities/institution.entity';
import { CreateStudentDto } from '../dto/create-student.dto';
import { StudentEntity } from '../entities/student.entity';

@Injectable()
export class CreateStudentUseCase {
  constructor(
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    @InjectRepository(InstitutionEntity)
    private readonly institutionRepository: Repository<InstitutionEntity>,
    private readonly jwtService: JwtService,
  ) {}

  async execute(dto: CreateStudentDto): Promise<SignInResponseDto> {
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
      role: RolesEnum.STUDENT,
      address: dto.address,
    });

    await this.userRepository.save(user);

    const student = this.studentRepository.create({
      cpf: dto.cpf,
      rg: dto.rg,
      course: dto.course,
      institutionId: dto.institutionId,
      userId: user.id,
      balance: 0,
    });

    await this.studentRepository.save(student);

    const payload = { sub: user.id, email: user.email, role: user.role };
    const accessToken = await this.jwtService.signAsync(payload);
    return plainToClass(SignInResponseDto, { accessToken });
  }
}
