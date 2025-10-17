import { ConflictException, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import bcrypt from 'bcrypt';
import { plainToClass } from 'class-transformer';
import { Repository } from 'typeorm';
import { SignInResponseDto } from '../../auth/dto/signin-response.dto';
import { UserEntity } from '../../auth/entities/user.entity';
import { RolesEnum } from '../../auth/consts/roles.enum';
import { CreateCompanyDto } from '../dto/create-company.dto';
import { CompanyEntity } from '../entities/company.entity';

@Injectable()
export class CreateCompanyUseCase {
  constructor(
    @InjectRepository(CompanyEntity)
    private readonly companyRepository: Repository<CompanyEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    private readonly jwtService: JwtService,
  ) {}

  async execute(dto: CreateCompanyDto): Promise<SignInResponseDto> {
    const existingUser = await this.userRepository.findOne({ where: { email: dto.email } });
    if (existingUser) {
      throw new ConflictException('User already exists');
    }

    const hashedPassword = await bcrypt.hash(dto.password, 10);

    const user = this.userRepository.create({
      email: dto.email,
      password: hashedPassword,
      name: dto.name,
      role: RolesEnum.COMPANY,
      address: dto.address,
    });

    await this.userRepository.save(user);

    const company = this.companyRepository.create({
      cnpj: dto.cnpj,
      description: dto.description,
      userId: user.id,
    });

    await this.companyRepository.save(company);

    const payload = { sub: user.id, email: user.email, role: user.role };
    const accessToken = await this.jwtService.signAsync(payload);
    return plainToClass(SignInResponseDto, { accessToken });
  }
}
