import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { plainToClass } from 'class-transformer';
import { Repository } from 'typeorm';
import { SignInRequestDto } from '../dto/signin-request.dto';
import { SignInResponseDto } from '../dto/signin-response.dto';
import { UserEntity } from '../entities/user.entity';
import { TeacherEntity } from 'src/teachers/entities/teacher.entity';
import { CompanyEntity } from 'src/companies/entities/company.entity';
import { StudentEntity } from 'src/students/entities/student.entity';
import { RolesEnum } from '../consts/roles.enum';

type Input = SignInRequestDto;
type Output = SignInResponseDto;

@Injectable()
export class SignInUseCase {
  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    @InjectRepository(TeacherEntity)
    private readonly teacherRepository: Repository<TeacherEntity>,
    @InjectRepository(CompanyEntity)
    private readonly companyRepository: Repository<CompanyEntity>,
    @InjectRepository(StudentEntity)
    private readonly studentRepository: Repository<StudentEntity>,
    private readonly jwtService: JwtService
  ) {}

  private repoOfRole = {
    [RolesEnum.TEACHER]: this.teacherRepository,
    [RolesEnum.COMPANY]: this.companyRepository,
    [RolesEnum.STUDENT]: this.studentRepository,
    [RolesEnum.ADMIN]: null,
  };

  async execute({ email, password }: Input): Promise<Output> {
    const user = await this.userRepository.findOne({ where: { email } });
    if (!user || !(await user.comparePassword(password))) {
      throw new UnauthorizedException('Invalid credentials');
    }
    const repo = this.repoOfRole[user.role as RolesEnum];
    // @ts-expect-error
    delete user.password;
    const profile = await repo?.findOne({ where: { user: { id: user.id } } });
    const payload = { sub: user.id, profile, ...user };
    const accessToken = await this.jwtService.signAsync(payload);
    return plainToClass(SignInResponseDto, { accessToken });
  }
}
