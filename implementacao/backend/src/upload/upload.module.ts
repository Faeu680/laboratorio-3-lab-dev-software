import { Module } from '@nestjs/common';
import { UPLOAD_GATEWAY } from './gateway/upload.gateway';
import { R2Service } from './services/r2.service';
import { UploadController } from './upload.controller';
import { GetUploadUrlUseCase } from './usecase/get-upload-url.usecase';

@Module({
  providers: [
    GetUploadUrlUseCase,
    {
      provide: UPLOAD_GATEWAY,
      useClass: R2Service,
    },
  ],
  controllers: [UploadController],
  exports: [UPLOAD_GATEWAY],
})
export class UploadModule {}
