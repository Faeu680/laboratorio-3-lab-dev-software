import { ApiProperty } from '@nestjs/swagger';

export class StudentResponseDto {
  @ApiProperty({ description: 'ID do aluno' })
  id: string;

  @ApiProperty({ description: 'Nome do aluno' })
  name: string;

  @ApiProperty({ description: 'Email do aluno' })
  email: string;

  @ApiProperty({ description: 'CPF do aluno' })
  cpf: string;

  @ApiProperty({ description: 'RG do aluno' })
  rg: string;

  @ApiProperty({ description: 'Curso do aluno' })
  course: string;

  @ApiProperty({ description: 'Saldo de moedas do aluno' })
  balance: number;

  @ApiProperty({ description: 'ID da instituição' })
  institutionId: string;

  @ApiProperty({ description: 'Nome da instituição' })
  institutionName?: string;
}
