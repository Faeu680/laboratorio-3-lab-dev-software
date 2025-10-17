import { ApiProperty } from '@nestjs/swagger';

export class InstitutionResponseDto {
  @ApiProperty({ description: 'ID da instituição' })
  id: string;

  @ApiProperty({ description: 'Nome da instituição' })
  name: string;

  @ApiProperty({ description: 'Endereço da instituição' })
  address: string;

  @ApiProperty({ description: 'Email da instituição' })
  email: string;

  @ApiProperty({ description: 'Telefone da instituição', required: false })
  phone?: string;
}
