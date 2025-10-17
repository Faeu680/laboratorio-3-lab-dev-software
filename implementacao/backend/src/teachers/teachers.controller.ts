import { Controller, Get, Post } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { RolesEnum } from '../auth/consts/roles.enum';
import { GetUser } from '../auth/decorators/get-user.decorator';
import { Roles } from '../auth/decorators/permission-scope.decorator';
import { AuthPayload } from '../auth/types/auth.types';
import { TeacherBalanceDto } from './dto/teacher-balance.dto';
import { CreditSemesterResponseDto } from './dto/teacher-response.dto';
import { CreditSemesterCoinsUseCase } from './usecases/credit-semester-coins.usecase';
import { GetTeacherBalanceUseCase } from './usecases/get-teacher-balance.usecase';

@ApiTags('Teachers')
@ApiBearerAuth()
@Controller('teachers')
export class TeachersController {
  constructor(
    private readonly getTeacherBalanceUseCase: GetTeacherBalanceUseCase,
    private readonly creditSemesterCoinsUseCase: CreditSemesterCoinsUseCase
  ) {}

  @Roles(RolesEnum.TEACHER)
  @Get('balance')
  @ApiOperation({ summary: 'Consultar saldo de moedas do professor autenticado' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Saldo retornado com sucesso',
    type: TeacherBalanceDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas professores' })
  @ApiWrappedResponse({ status: 404, description: 'Professor não encontrado' })
  async getBalance(@GetUser() user: AuthPayload): Promise<TeacherBalanceDto> {
    return this.getTeacherBalanceUseCase.execute(user.sub);
  }

  @Roles(RolesEnum.TEACHER)
  @Post('credit-semester')
  @ApiOperation({ summary: 'Creditar 1000 moedas semestrais para o professor autenticado' })
  @ApiWrappedResponse({
    status: 201,
    description: 'Moedas creditadas com sucesso. O saldo é acumulável.',
    type: CreditSemesterResponseDto,
  })
  @ApiWrappedResponse({ status: 401, description: 'Não autorizado' })
  @ApiWrappedResponse({ status: 403, description: 'Acesso negado - apenas professores' })
  @ApiWrappedResponse({ status: 404, description: 'Professor não encontrado' })
  async creditSemester(@GetUser() user: AuthPayload): Promise<CreditSemesterResponseDto> {
    return this.creditSemesterCoinsUseCase.execute(user.sub);
  }
}
