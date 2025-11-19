export const UPLOAD_GATEWAY = 'UPLOAD_GATEWAY';

export interface UploadGateway {
  generatePresignedPutUrl(path: string, fileType: string): Promise<string>;
  generatePresignedGetUrl(path: string): Promise<string>;
}
