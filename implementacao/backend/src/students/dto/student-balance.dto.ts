import { ApiProperty } from '@nestjs/swagger';

export class StudentBalanceDto {
  @ApiProperty()
  balance: number;

  @ApiProperty()
  studentId: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  email: string;
}
