import { ApiProperty } from '@nestjs/swagger';

export class GetUploadUrlResponseDto {
  @ApiProperty()
  path: string;

  @ApiProperty()
  presignedUrl: string;
}
