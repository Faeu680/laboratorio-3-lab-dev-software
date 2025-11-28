import { ApiProperty } from '@nestjs/swagger';

export class BenefitResponseDto {
  @ApiProperty({ description: 'ID da vantagem' })
  id: string;

  @ApiProperty({ description: 'Nome da vantagem' })
  name: string;

  @ApiProperty({ description: 'Descrição da vantagem' })
  description: string;

  @ApiProperty({ description: 'URL da foto da vantagem', required: false })
  photo?: string;

  @ApiProperty({ description: 'Custo em moedas' })
  cost: string;

  @ApiProperty({ description: 'Se a vantagem está ativa' })
  active: boolean;

  @ApiProperty({ description: 'ID da empresa parceira' })
  companyId: string;

  @ApiProperty({ description: 'Nome da empresa parceira', required: false })
  companyName?: string;
}
