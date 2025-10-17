import { ApiProperty } from '@nestjs/swagger';

export class TeacherBalanceDto {
  @ApiProperty()
  balance: number;

  @ApiProperty()
  teacherId: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  email: string;

  @ApiProperty()
  lastCreditDate: Date | null;
}
