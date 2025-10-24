import { Body, Controller, Delete, Get, Param, Patch, Post } from '@nestjs/common';
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
import { StudentResponseDto } from './dto/student-response.dto';
import { UpdateStudentDto } from './dto/update-student.dto';
import { CreateStudentUseCase } from './usecases/create-student.usecase';
import { DeleteStudentUseCase } from './usecases/delete-student.usecase';
import { FindAllStudentsUseCase } from './usecases/find-all-students.usecase';
import { FindStudentByIdUseCase } from './usecases/find-student-by-id.usecase';
import { GetStudentBalanceUseCase } from './usecases/get-student-balance.usecase';
import { UpdateStudentUseCase } from './usecases/update-student.usecase';

@ApiTags('Students')
@ApiBearerAuth()
@Controller('students')
export class StudentsController {
  constructor(
    private readonly createStudentUseCase: CreateStudentUseCase,
    private readonly getStudentBalanceUseCase: GetStudentBalanceUseCase,
    private readonly updateStudentUseCase: UpdateStudentUseCase,
    private readonly deleteStudentUseCase: DeleteStudentUseCase,
    private readonly findAllStudentsUseCase: FindAllStudentsUseCase,
    private readonly findStudentByIdUseCase: FindStudentByIdUseCase
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

  @Roles(RolesEnum.ADMIN)
  @Get()
  @ApiOperation({ summary: 'Listar todos os alunos' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Lista de alunos retornada com sucesso',
    type: [StudentResponseDto],
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas administradores' })
  async findAll(): Promise<StudentResponseDto[]> {
    return this.findAllStudentsUseCase.execute();
  }

  @Roles(RolesEnum.ADMIN)
  @Get(':id')
  @ApiOperation({ summary: 'Buscar aluno por ID' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Aluno encontrado com sucesso',
    type: StudentResponseDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas administradores' })
  @ApiWrappedResponse({ status: 404, description: 'Aluno não encontrado' })
  async findById(@Param('id') id: string): Promise<StudentResponseDto> {
    return this.findStudentByIdUseCase.execute(id);
  }

  @Roles(RolesEnum.ADMIN)
  @Patch(':id')
  @ApiOperation({ summary: 'Atualizar dados de um aluno' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Aluno atualizado com sucesso',
    type: StudentResponseDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas administradores' })
  @ApiWrappedResponse({ status: 404, description: 'Aluno não encontrado' })
  @ApiWrappedResponse({ status: 409, description: 'Email já está em uso' })
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateStudentDto
  ): Promise<StudentResponseDto> {
    return this.updateStudentUseCase.execute(id, dto);
  }

  @Roles(RolesEnum.ADMIN)
  @Delete(':id')
  @ApiOperation({ summary: 'Deletar um aluno' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Aluno deletado com sucesso',
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas administradores' })
  @ApiWrappedResponse({ status: 404, description: 'Aluno não encontrado' })
  async delete(@Param('id') id: string): Promise<void> {
    return this.deleteStudentUseCase.execute(id);
  }
}
