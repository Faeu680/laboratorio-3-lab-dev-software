import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BenefitEntity } from '../entities/benefit.entity';

@Injectable()
export class ListBenefitsUseCase {
  constructor(
    @InjectRepository(BenefitEntity)
    private readonly benefitRepository: Repository<BenefitEntity>,
  ) {}

  async execute(): Promise<BenefitEntity[]> {
    return this.benefitRepository.find({
      where: { active: true },
      relations: ['company', 'company.user'],
    });
  }
}
