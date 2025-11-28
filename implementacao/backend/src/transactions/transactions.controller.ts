import { Body, Controller, Get, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { RolesEnum } from '../auth/consts/roles.enum';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { Roles } from '../auth/decorators/permission-scope.decorator';
import { BalanceDto } from './dto/balance.dto';
import { RedeemBenefitDto } from './dto/redeem-benefit.dto';
import { TransactionResponseDto } from './dto/transaction-response.dto';
import { TransferCoinsDto } from './dto/transfer-coins.dto';
import { GetBalanceUseCase } from './usecases/get-balance.usecase';
import { GetExtractUseCase } from './usecases/get-extract.usecase';
import { RedeemBenefitUseCase } from './usecases/redeem-benefit.usecase';
import { TransferCoinsUseCase } from './usecases/transfer-coins.usecase';
import { AuthUser } from 'src/auth/types/auth.types';

@ApiTags('Transactions')
@ApiBearerAuth()
@Controller('transactions')
export class TransactionsController {
  constructor(
    private readonly transferCoinsUseCase: TransferCoinsUseCase,
    private readonly redeemBenefitUseCase: RedeemBenefitUseCase,
    private readonly getExtractUseCase: GetExtractUseCase,
    private readonly getBalanceUseCase: GetBalanceUseCase
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
    @GetUser() user: AuthUser,
    @Body() dto: TransferCoinsDto
  ): Promise<TransactionResponseDto> {
    const tr = await this.transferCoinsUseCase.execute(user.id, dto);
    return {
      ...tr,
      amount: tr.amount.toString(),
    }
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
    @GetUser() user: AuthUser,
    @Body() dto: RedeemBenefitDto
  ): Promise<TransactionResponseDto> {
    const tr = await this.redeemBenefitUseCase.execute(user.id, dto);
    return {
      ...tr,
      amount: tr.amount.toString(),
    }
  }

  @Get('extract')
  @ApiOperation({ summary: 'Consultar extrato de transações do usuário autenticado' })
  @ApiWrappedResponse({
    status: 200,
    description:
      'Extrato retornado com sucesso. Mostra transferências (professor) ou recebimentos/resgates (aluno).',
    type: TransactionResponseDto,
    isArray: true,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  async getExtract(@GetUser() user: AuthUser): Promise<TransactionResponseDto[]> {
    return this.getExtractUseCase.execute(user.id, user.role);
  }

  @Get('balance')
  @ApiOperation({ summary: 'Consultar extrato de transações do usuário autenticado' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Saldo retornado com sucesso. Mostra saldo do aluno ou professor',
    type: BalanceDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  async getBalance(@GetUser() user: AuthUser): Promise<BalanceDto> {
    const balance = await this.getBalanceUseCase.execute(user);

    return {
      balance: balance.balance.toString(),
    }
  }
}
