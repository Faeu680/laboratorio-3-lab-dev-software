import { Body, Controller, Delete, Get, Param, Patch, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { RolesEnum } from '../auth/consts/roles.enum';
import { Roles } from '../auth/decorators/permission-scope.decorator';
import { SkipAuth } from '../auth/decorators/skip-auth.decorator';
import { SignInResponseDto } from '../auth/dto/signin-response.dto';
import { CompanyResponseDto } from './dto/company-response.dto';
import { CreateCompanyDto } from './dto/create-company.dto';
import { UpdateCompanyDto } from './dto/update-company.dto';
import { CreateCompanyUseCase } from './usecases/create-company.usecase';
import { DeleteCompanyUseCase } from './usecases/delete-company.usecase';
import { FindAllCompaniesUseCase } from './usecases/find-all-companies.usecase';
import { FindCompanyByIdUseCase } from './usecases/find-company-by-id.usecase';
import { UpdateCompanyUseCase } from './usecases/update-company.usecase';

@ApiTags('Companies')
@ApiBearerAuth()
@Controller('companies')
export class CompaniesController {
  constructor(
    private readonly createCompanyUseCase: CreateCompanyUseCase,
    private readonly updateCompanyUseCase: UpdateCompanyUseCase,
    private readonly deleteCompanyUseCase: DeleteCompanyUseCase,
    private readonly findAllCompaniesUseCase: FindAllCompaniesUseCase,
    private readonly findCompanyByIdUseCase: FindCompanyByIdUseCase
  ) {}

  @SkipAuth()
  @Post()
  @ApiOperation({ summary: 'Cadastrar uma nova empresa parceira' })
  @ApiWrappedResponse({
    status: 201,
    description: 'Empresa cadastrada com sucesso. Retorna token de autenticação.',
    type: SignInResponseDto,
  })
  @ApiWrappedResponse({ status: 409, description: 'Usuário já existe' })
  async create(@Body() dto: CreateCompanyDto): Promise<SignInResponseDto> {
    return this.createCompanyUseCase.execute(dto);
  }

  @Roles(RolesEnum.ADMIN)
  @Get()
  @ApiOperation({ summary: 'Listar todas as empresas parceiras' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Lista de empresas retornada com sucesso',
    type: [CompanyResponseDto],
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas administradores' })
  async findAll(): Promise<CompanyResponseDto[]> {
    return this.findAllCompaniesUseCase.execute();
  }

  @Roles(RolesEnum.ADMIN)
  @Get(':id')
  @ApiOperation({ summary: 'Buscar empresa parceira por ID' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Empresa encontrada com sucesso',
    type: CompanyResponseDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas administradores' })
  @ApiWrappedResponse({ status: 404, description: 'Empresa não encontrada' })
  async findById(@Param('id') id: string): Promise<CompanyResponseDto> {
    return this.findCompanyByIdUseCase.execute(id);
  }

  @Roles(RolesEnum.ADMIN)
  @Patch(':id')
  @ApiOperation({ summary: 'Atualizar dados de uma empresa parceira' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Empresa atualizada com sucesso',
    type: CompanyResponseDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas administradores' })
  @ApiWrappedResponse({ status: 404, description: 'Empresa não encontrada' })
  @ApiWrappedResponse({ status: 409, description: 'Email já está em uso' })
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateCompanyDto
  ): Promise<CompanyResponseDto> {
    return this.updateCompanyUseCase.execute(id, dto);
  }

  @Roles(RolesEnum.ADMIN)
  @Delete(':id')
  @ApiOperation({ summary: 'Deletar uma empresa parceira' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Empresa deletada com sucesso',
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas administradores' })
  @ApiWrappedResponse({ status: 404, description: 'Empresa não encontrada' })
  async delete(@Param('id') id: string): Promise<void> {
    return this.deleteCompanyUseCase.execute(id);
  }
}
