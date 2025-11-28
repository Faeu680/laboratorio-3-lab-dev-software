import { ApiProperty } from '@nestjs/swagger';
import { TransactionResponseDto } from 'src/transactions/dto/transaction-response.dto';
import { BenefitResponseDto } from './benefit-response.dto';

export class MyBenefitResponseDto extends TransactionResponseDto {
  @ApiProperty({ type: BenefitResponseDto })
  benefit: BenefitResponseDto;
}
