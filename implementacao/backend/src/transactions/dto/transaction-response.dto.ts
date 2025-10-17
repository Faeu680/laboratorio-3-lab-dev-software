import { ApiProperty } from '@nestjs/swagger';
import { TransactionTypeEnum } from '../entities/transaction.entity';

export class TransactionResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ enum: TransactionTypeEnum })
  type: TransactionTypeEnum;

  @ApiProperty()
  amount: number;

  @ApiProperty()
  message: string | null;

  @ApiProperty()
  voucherCode: string | null;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty({ required: false })
  studentName?: string;

  @ApiProperty({ required: false })
  teacherName?: string;

  @ApiProperty({ required: false })
  benefitName?: string;

  @ApiProperty({ required: false })
  companyName?: string;
}
