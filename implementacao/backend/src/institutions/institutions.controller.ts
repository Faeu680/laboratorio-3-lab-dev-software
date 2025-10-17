import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { SkipAuth } from '../auth/decorators/skip-auth.decorator';
import { InstitutionResponseDto } from './dto/institution-response.dto';
import { ListInstitutionsUseCase } from './usecases/list-institutions.usecase';

@ApiTags('Institutions')
@ApiBearerAuth()
@Controller('institutions')
export class InstitutionsController {
  constructor(private readonly listInstitutionsUseCase: ListInstitutionsUseCase) {}

  @SkipAuth()
  @Get()
  @ApiOperation({ summary: 'Listar todas as instituições disponíveis' })
  @ApiWrappedResponse({
    status: 200,
    description: 'Lista de instituições retornada com sucesso',
    type: [InstitutionResponseDto],
  })
  async list(): Promise<InstitutionResponseDto[]> {
    return this.listInstitutionsUseCase.execute();
  }
}
