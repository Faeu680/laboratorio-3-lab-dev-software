import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import {
  TransactionEntity,
  TransactionTypeEnum,
} from 'src/transactions/entities/transaction.entity';
import { UPLOAD_GATEWAY, UploadGateway } from 'src/upload/gateway/upload.gateway';
import { Repository } from 'typeorm';

@Injectable()
export class ListMyBenefitsUseCase {
  constructor(
    @InjectRepository(TransactionEntity)
    private readonly transactionRepository: Repository<TransactionEntity>,
    @Inject(UPLOAD_GATEWAY)
    private readonly uploadService: UploadGateway
  ) {}

  async execute(studentId: string): Promise<TransactionEntity[]> {
    const res = await this.transactionRepository.find({
      where: {
        studentId,
        type: TransactionTypeEnum.REDEMPTION,
      },
      relations: ['benefit'],
    });

    for (const item of res) {
      if (!item.benefit.photo) continue;
      item.benefit.photo = await this.uploadService.generatePresignedGetUrl(item.benefit.photo);
    }

    return res;
  }
}
