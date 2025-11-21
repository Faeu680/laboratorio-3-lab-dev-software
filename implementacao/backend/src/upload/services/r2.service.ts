import { GetObjectCommand, PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Injectable } from '@nestjs/common';
import { env } from 'src/config/env';
import { UploadGateway } from '../gateway/upload.gateway';

@Injectable()
export class R2Service implements UploadGateway {
  private s3: S3Client;

  constructor() {
    this.s3 = new S3Client({
      region: 'auto',
      endpoint: env.S3_ENDPOINT,
      credentials: {
        accessKeyId: env.S3_ACCESS_KEY_ID,
        secretAccessKey: env.S3_SECRET_ACCESS_KEY,
      },
    });
  }

  async generatePresignedPutUrl(path: string, fileType: string): Promise<string> {
    const command = new PutObjectCommand({
      Bucket: env.S3_BUCKET,
      Key: path,
      ContentType: fileType,
      ACL: 'public-read',
    });

    return await getSignedUrl(this.s3, command, { expiresIn: 60 * 5 }); // 5 min
  }

  async generatePresignedGetUrl(path: string): Promise<string> {
    if (path.startsWith('http')) {
      return path;
    }

    const command = new GetObjectCommand({
      Bucket: env.S3_BUCKET,
      Key: path,
    });
    return await getSignedUrl(this.s3, command, { expiresIn: 60 * 5 }); // 5 min
  }
}
