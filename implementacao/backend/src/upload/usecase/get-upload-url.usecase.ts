import { randomUUID } from 'node:crypto';
import { Inject, Injectable } from '@nestjs/common';
import { GetUploadUrlDto } from '../dto/get-upload-url.dto';
import { GetUploadUrlResponseDto } from '../dto/get-upload-url-response.dto';
import { UPLOAD_GATEWAY, UploadGateway } from '../gateway/upload.gateway';

type Input = {
  data: GetUploadUrlDto;
};

type Output = GetUploadUrlResponseDto;

@Injectable()
export class GetUploadUrlUseCase {
  constructor(@Inject(UPLOAD_GATEWAY) private readonly uploadGateway: UploadGateway) {}

  async execute({ data }: Input): Promise<Output> {
    const newName = randomUUID();
    const path = `images/${newName}`;
    const presignedUrl = await this.uploadGateway.generatePresignedPutUrl(path, data.mimeType);

    return {
      path,
      presignedUrl,
    };
  }
}
