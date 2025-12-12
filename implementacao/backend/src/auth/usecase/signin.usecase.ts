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

  async execute({ email, password }: Input): Promise<Output> {
    const user = await this.findUserByEmail(email);
    
    if (!user || !(await user.comparePassword(password))) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const profile = await this.findUserProfile(user);
    const userWithoutPassword = this.removePasswordFromUser(user);
    const payload = { sub: user.id, profile, ...userWithoutPassword };
    const accessToken = await this.jwtService.signAsync(payload);
    
    return plainToClass(SignInResponseDto, { accessToken });
  }

  private async findUserByEmail(email: string): Promise<UserEntity | null> {
    return this.userRepository.findOne({ where: { email } });
  }

  private async findUserProfile(
    user: UserEntity
  ): Promise<TeacherEntity | CompanyEntity | StudentEntity | null> {
    const { repository, relations } = this.getRepositoryForRole(user.role);
    
    if (!repository) {
      return null;
    }

    return repository.findOne({
      where: { user: { id: user.id } },
      relations,
    }) as Promise<TeacherEntity | CompanyEntity | StudentEntity | null>;
  }

  private getRepositoryForRole(role: RolesEnum): {
    repository: Repository<TeacherEntity | CompanyEntity | StudentEntity> | null;
    relations: string[];
  } {
    const roleConfig: Record<
      RolesEnum,
      {
        repository: Repository<TeacherEntity | CompanyEntity | StudentEntity> | null;
        relations: string[];
      }
    > = {
      [RolesEnum.TEACHER]: {
        repository: this.teacherRepository as Repository<TeacherEntity | CompanyEntity | StudentEntity>,
        relations: ['institution'],
      },
      [RolesEnum.COMPANY]: {
        repository: this.companyRepository as Repository<TeacherEntity | CompanyEntity | StudentEntity>,
        relations: [],
      },
      [RolesEnum.STUDENT]: {
        repository: this.studentRepository as Repository<TeacherEntity | CompanyEntity | StudentEntity>,
        relations: ['institution'],
      },
      [RolesEnum.ADMIN]: {
        repository: null,
        relations: [],
      },
    };

    return roleConfig[role] || { repository: null, relations: [] };
  }

  private removePasswordFromUser(user: UserEntity): Omit<UserEntity, 'password'> {
    const { password, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }
}
