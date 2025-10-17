import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsUUID } from 'class-validator';

export class RedeemBenefitDto {
  @ApiProperty()
  @IsUUID()
  @IsNotEmpty()
  benefitId: string;
}
