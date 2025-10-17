import { Body, Controller, Get, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { RolesEnum } from '../auth/consts/roles.enum';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { Roles } from '../auth/decorators/permission-scope.decorator';
import { AuthPayload } from '../auth/types/auth.types';
import { BenefitResponseDto } from './dto/benefit-response.dto';
import { CreateBenefitDto } from './dto/create-benefit.dto';
import { CreateBenefitUseCase } from './usecases/create-benefit.usecase';
import { ListBenefitsUseCase } from './usecases/list-benefits.usecase';

@ApiTags('Benefits')
@ApiBearerAuth()
@Controller('benefits')
export class BenefitsController {
  constructor(
    private readonly createBenefitUseCase: CreateBenefitUseCase,
    private readonly listBenefitsUseCase: ListBenefitsUseCase
  ) {}

  @Roles(RolesEnum.COMPANY)
  @Post()
  @ApiOperation({ summary: 'Cadastrar uma nova vantagem (empresa parceira)' })
  @ApiWrappedResponse({
    status: 201,
    description: 'Vantagem cadastrada com sucesso',
    type: BenefitResponseDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas empresas' })
  @ApiWrappedResponse({ status: 404, description: 'Empresa não encontrada' })
  async create(
    @GetUser() user: AuthPayload,
    @Body() dto: CreateBenefitDto
  ): Promise<BenefitResponseDto> {
    return this.createBenefitUseCase.execute(user.sub, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Listar todas as vantagens ativas disponíveis' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Lista de vantagens retornada com sucesso',
    type: [BenefitResponseDto],
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  async list(): Promise<BenefitResponseDto[]> {
    return this.listBenefitsUseCase.execute();
  }
}
