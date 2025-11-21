import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UPLOAD_GATEWAY, UploadGateway } from 'src/upload/gateway/upload.gateway';
import { Repository } from 'typeorm';
import { BenefitEntity } from '../entities/benefit.entity';

@Injectable()
export class ListBenefitsUseCase {
  constructor(
    @InjectRepository(BenefitEntity)
    private readonly benefitRepository: Repository<BenefitEntity>,
    @Inject(UPLOAD_GATEWAY)
    private readonly uploadService: UploadGateway
  ) {}

  async execute(): Promise<BenefitEntity[]> {
    const res = await this.benefitRepository.find({
      where: { active: true },
      relations: ['company', 'company.user'],
    });

    for (const item of res) {
      if (!item.photo) continue;
      item.photo = await this.uploadService.generatePresignedGetUrl(item.photo);
    }

    return res;
  }
}
