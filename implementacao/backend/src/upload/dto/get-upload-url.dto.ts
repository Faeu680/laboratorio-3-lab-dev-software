import { ApiProperty } from '@nestjs/swagger';
import { IsMimeType, IsNotEmpty, IsString } from 'class-validator';

export class GetUploadUrlDto {
  @IsString()
  @IsNotEmpty()
  @ApiProperty()
  originalName: string;

  @IsMimeType()
  @IsNotEmpty()
  @ApiProperty()
  mimeType: string;
}
