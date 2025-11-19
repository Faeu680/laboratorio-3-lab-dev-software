import { Body, Controller, Post } from '@nestjs/common';
import { ApiWrappedResponse } from 'src/@shared/interceptors/api-wrapped-response';
import { GetUploadUrlDto } from './dto/get-upload-url.dto';
import { GetUploadUrlResponseDto } from './dto/get-upload-url-response.dto';
import { GetUploadUrlUseCase } from './usecase/get-upload-url.usecase';
import { SkipAuth } from 'src/auth/decorators/skip-auth.decorator';

@Controller('upload')
export class UploadController {
  constructor(private readonly getUploadUrlUseCase: GetUploadUrlUseCase) {}

  @Post('presigned-url')
  @SkipAuth()
  @ApiWrappedResponse({
    status: 201,
    description: 'URL de upload gerada com sucesso',
    type: GetUploadUrlResponseDto,
  })
  async getPresignedUrl(@Body() data: GetUploadUrlDto): Promise<GetUploadUrlResponseDto> {
    return await this.getUploadUrlUseCase.execute({
      data,
    });
  }
}
