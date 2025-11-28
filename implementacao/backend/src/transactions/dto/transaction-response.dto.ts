import { ApiProperty } from '@nestjs/swagger';
import { TransactionTypeEnum } from '../entities/transaction.entity';

export class TransactionResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ enum: TransactionTypeEnum })
  type: TransactionTypeEnum;

  @ApiProperty()
  amount: string;

  @ApiProperty()
  message: string;

  @ApiProperty({
    nullable: true,
  })
  voucherCode: string;

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

  @ApiProperty()
  origin?: string;
}
