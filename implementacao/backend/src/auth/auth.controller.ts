import { Body, Controller, Post } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { SkipAuth } from './decorators/skip-auth.decorator';
import { SignInRequestDto } from './dto/signin-request.dto';
import { SignInResponseDto } from './dto/signin-response.dto';
import { SignInUseCase } from './usecase/signin.usecase';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly signInUseCase: SignInUseCase) {}

  @SkipAuth()
  @Post('signin')
  @ApiOperation({
    summary: 'Fazer login no sistema',
    description: 'Autenticar usuário (aluno, professor ou empresa) e receber token JWT',
  })
  @ApiWrappedResponse({
    status: 200,
    description: 'Login realizado com sucesso. Retorna token de acesso.',
    type: SignInResponseDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Credenciais inválidas' })
  async login(@Body() body: SignInRequestDto): Promise<SignInResponseDto> {
    return this.signInUseCase.execute(body);
  }
}
