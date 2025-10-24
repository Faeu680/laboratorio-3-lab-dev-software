import { ApiProperty } from '@nestjs/swagger';

export class CompanyResponseDto {
  @ApiProperty({ description: 'ID da empresa' })
  id: string;

  @ApiProperty({ description: 'Nome da empresa' })
  name: string;

  @ApiProperty({ description: 'Email da empresa' })
  email: string;

  @ApiProperty({ description: 'CNPJ da empresa' })
  cnpj: string;

  @ApiProperty({ description: 'Descrição da empresa', required: false })
  description?: string;
}
