import { Body, Controller, Get, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { RolesEnum } from '../auth/consts/roles.enum';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { Roles } from '../auth/decorators/permission-scope.decorator';
import { AuthUser } from '../auth/types/auth.types';
import { BenefitResponseDto } from './dto/benefit-response.dto';
import { CreateBenefitDto } from './dto/create-benefit.dto';
import { CreateBenefitUseCase } from './usecases/create-benefit.usecase';
import { ListBenefitsUseCase } from './usecases/list-benefits.usecase';
import { MyBenefitResponseDto } from './dto/my-benefit-response.dto';
import { ListMyBenefitsUseCase } from './usecases/list-my-benefits.usecase';

@ApiTags('Benefits')
@ApiBearerAuth()
@Controller('benefits')
export class BenefitsController {
  constructor(
    private readonly createBenefitUseCase: CreateBenefitUseCase,
    private readonly listBenefitsUseCase: ListBenefitsUseCase,
    private readonly myBenefitsUseCase: ListMyBenefitsUseCase
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
    @GetUser() user: AuthUser,
    @Body() dto: CreateBenefitDto
  ): Promise<BenefitResponseDto> {
    const result = await this.createBenefitUseCase.execute(user.id, dto);
    return {
      active: result.active,
      companyId: result.companyId,
      cost: parseInt(result.cost.toString(), 10).toString(),
      description: result.description,
      id: result.id,
      name: result.name,
      companyName: result.company?.user?.name,
      photo: result.photo,
    };
  }

  @Get()
  @ApiOperation({ summary: 'Listar todas as vantagens ativas disponíveis' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Lista de vantagens retornada com sucesso',
    type: BenefitResponseDto,
    isArray: true,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  async list(): Promise<BenefitResponseDto[]> {
    return (await this.listBenefitsUseCase.execute()).map((result) => {
      return {
        active: result.active,
        companyId: result.companyId,
        cost: parseInt(result.cost.toString(), 10).toString(),
        description: result.description,
        id: result.id,
        name: result.name,
        companyName: result.company?.user?.name,
        photo: result.photo,
      };
    });
  }

  @Roles(RolesEnum.STUDENT)
  @Get('my-benefits')
  @ApiOperation({ summary: 'Listar todas as vantagens resgatadas' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Lista de vantagens retornada com sucesso',
    type: MyBenefitResponseDto,
    isArray: true,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  async myBenefits(@GetUser() user: AuthUser): Promise<MyBenefitResponseDto[]> {
    return (await this.myBenefitsUseCase.execute(user.profileId)).map((result) => {
      return {
        ...result,
        amount: result.amount.toString(),
        benefit: {
          ...result.benefit,
          cost: parseInt(result.benefit.cost.toString(), 10).toString(),
        },
      };
    });
  }
}
