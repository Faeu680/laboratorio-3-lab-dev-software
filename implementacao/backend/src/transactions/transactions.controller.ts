import { Body, Controller, Get, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { RolesEnum } from '../auth/consts/roles.enum';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { Roles } from '../auth/decorators/permission-scope.decorator';
import { AuthPayload } from '../auth/types/auth.types';
import { RedeemBenefitDto } from './dto/redeem-benefit.dto';
import { TransactionResponseDto } from './dto/transaction-response.dto';
import { TransferCoinsDto } from './dto/transfer-coins.dto';
import { GetExtractUseCase } from './usecases/get-extract.usecase';
import { RedeemBenefitUseCase } from './usecases/redeem-benefit.usecase';
import { TransferCoinsUseCase } from './usecases/transfer-coins.usecase';

@ApiTags('Transactions')
@ApiBearerAuth()
@Controller('transactions')
export class TransactionsController {
  constructor(
    private readonly transferCoinsUseCase: TransferCoinsUseCase,
    private readonly redeemBenefitUseCase: RedeemBenefitUseCase,
    private readonly getExtractUseCase: GetExtractUseCase
  ) {}

  @Roles(RolesEnum.TEACHER)
  @Post('transfer')
  @ApiOperation({ summary: 'Transferir moedas para um aluno (professor apenas)' })
  @ApiWrappedResponse({
    status: 201,
    description: 'Moedas transferidas com sucesso. Email enviado ao aluno.',
    type: TransactionResponseDto,
  })
  @ApiWrappedResponse({ status: 400, description: 'Saldo insuficiente' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas professores' })
  @ApiWrappedResponse({ status: 404, description: 'Professor ou aluno não encontrado' })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  async transfer(
    @GetUser() user: AuthPayload,
    @Body() dto: TransferCoinsDto
  ): Promise<TransactionResponseDto> {
    return this.transferCoinsUseCase.execute(user.sub, dto);
  }

  @Roles(RolesEnum.STUDENT)
  @Post('redeem')
  @ApiOperation({ summary: 'Resgatar uma vantagem (aluno apenas)' })
  @ApiWrappedResponse({
    status: 201,
    description:
      'Vantagem resgatada com sucesso. Emails enviados ao aluno e à empresa com código do voucher.',
    type: TransactionResponseDto,
  })
  @ApiWrappedResponse({ status: 400, description: 'Saldo insuficiente' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas alunos' })
  @ApiWrappedResponse({ status: 404, description: 'Aluno ou vantagem não encontrada' })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  async redeem(
    @GetUser() user: AuthPayload,
    @Body() dto: RedeemBenefitDto
  ): Promise<TransactionResponseDto> {
    return this.redeemBenefitUseCase.execute(user.sub, dto);
  }

  @Get('extract')
  @ApiOperation({ summary: 'Consultar extrato de transações do usuário autenticado' })
  @ApiWrappedResponse({
    status: 200,
    description:
      'Extrato retornado com sucesso. Mostra transferências (professor) ou recebimentos/resgates (aluno).',
    type: [TransactionResponseDto],
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  async getExtract(@GetUser() user: AuthPayload): Promise<TransactionResponseDto[]> {
    return this.getExtractUseCase.execute(user.sub, user.role);
  }
}
