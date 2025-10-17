import { Body, Controller, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { SkipAuth } from '../auth/decorators/skip-auth.decorator';
import { SignInResponseDto } from '../auth/dto/signin-response.dto';
import { CreateCompanyDto } from './dto/create-company.dto';
import { CreateCompanyUseCase } from './usecases/create-company.usecase';

@ApiTags('Companies')
@ApiBearerAuth()
@Controller('companies')
export class CompaniesController {
  constructor(private readonly createCompanyUseCase: CreateCompanyUseCase) {}

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
}
