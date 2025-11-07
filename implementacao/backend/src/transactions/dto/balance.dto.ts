import { ApiProperty } from '@nestjs/swagger';

export class BalanceDto {
  @ApiProperty()
  balance: number;
}
