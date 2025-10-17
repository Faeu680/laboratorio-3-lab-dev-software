import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { plainToClass } from 'class-transformer';
import { Repository } from 'typeorm';
import { SignInRequestDto } from '../dto/signin-request.dto';
import { SignInResponseDto } from '../dto/signin-response.dto';
import { UserEntity } from '../entities/user.entity';

type Input = SignInRequestDto;
type Output = SignInResponseDto;

@Injectable()
export class SignInUseCase {
  constructor(
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>,
    private readonly jwtService: JwtService
  ) {}

  async execute({ email, password }: Input): Promise<Output> {
    const user = await this.userRepository.findOne({ where: { email } });
    if (!user || !(await user.comparePassword(password))) {
      throw new UnauthorizedException('Invalid credentials');
    }
    const payload = { sub: user.id, email: user.email, role: user.role };
    const accessToken = await this.jwtService.signAsync(payload);
    return plainToClass(SignInResponseDto, { accessToken });
  }
}
