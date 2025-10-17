import { ApiProperty } from '@nestjs/swagger';

export class TeacherResponseDto {
  @ApiProperty({ description: 'ID do professor' })
  id: string;

  @ApiProperty({ description: 'Nome do professor' })
  name: string;

  @ApiProperty({ description: 'Email do professor' })
  email: string;

  @ApiProperty({ description: 'CPF do professor' })
  cpf: string;

  @ApiProperty({ description: 'Departamento do professor' })
  department: string;

  @ApiProperty({ description: 'Saldo de moedas do professor' })
  balance: number;

  @ApiProperty({ description: 'Data do último crédito semestral', required: false })
  lastCreditDate?: Date;

  @ApiProperty({ description: 'ID da instituição' })
  institutionId: string;
}

export class CreditSemesterResponseDto {
  @ApiProperty({ description: 'Novo saldo após o crédito' })
  balance: number;

  @ApiProperty({ description: 'Quantidade de moedas creditadas' })
  credited: number;
}
