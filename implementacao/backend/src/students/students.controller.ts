import { Body, Controller, Get, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { RolesEnum } from '../auth/consts/roles.enum';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { Roles } from '../auth/decorators/permission-scope.decorator';
import { SkipAuth } from '../auth/decorators/skip-auth.decorator';
import { SignInResponseDto } from '../auth/dto/signin-response.dto';
import { AuthPayload } from '../auth/types/auth.types';
import { CreateStudentDto } from './dto/create-student.dto';
import { StudentBalanceDto } from './dto/student-balance.dto';
import { CreateStudentUseCase } from './usecases/create-student.usecase';
import { GetStudentBalanceUseCase } from './usecases/get-student-balance.usecase';

@ApiTags('Students')
@ApiBearerAuth()
@Controller('students')
export class StudentsController {
  constructor(
    private readonly createStudentUseCase: CreateStudentUseCase,
    private readonly getStudentBalanceUseCase: GetStudentBalanceUseCase
  ) {}

  @SkipAuth()
  @Post()
  @ApiOperation({ summary: 'Cadastrar um novo aluno no sistema' })
  @ApiWrappedResponse({
    status: 201,
    description: 'Aluno cadastrado com sucesso. Retorna token de autenticação.',
    type: SignInResponseDto,
  })
  @ApiWrappedResponse({ status: 409, description: 'Usuário já existe' })
  @ApiWrappedResponse({ status: 404, description: 'Instituição não encontrada' })
  async create(@Body() dto: CreateStudentDto): Promise<SignInResponseDto> {
    return this.createStudentUseCase.execute(dto);
  }

  @Roles(RolesEnum.STUDENT)
  @Get('balance')
  @ApiOperation({ summary: 'Consultar saldo de moedas do aluno autenticado' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Saldo retornado com sucesso',
    type: StudentBalanceDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas alunos' })
  @ApiWrappedResponse({ status: 404, description: 'Aluno não encontrado' })
  async getBalance(@GetUser() user: AuthPayload): Promise<StudentBalanceDto> {
    return this.getStudentBalanceUseCase.execute(user.sub);
  }
}
