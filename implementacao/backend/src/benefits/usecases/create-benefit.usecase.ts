import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CompanyEntity } from '../../companies/entities/company.entity';
import { CreateBenefitDto } from '../dto/create-benefit.dto';
import { BenefitEntity } from '../entities/benefit.entity';

@Injectable()
export class CreateBenefitUseCase {
  constructor(
    @InjectRepository(BenefitEntity)
    private readonly benefitRepository: Repository<BenefitEntity>,
    @InjectRepository(CompanyEntity)
    private readonly companyRepository: Repository<CompanyEntity>
  ) {}

  async execute(userId: string, dto: CreateBenefitDto): Promise<BenefitEntity> {
    const company = await this.companyRepository.findOne({ where: { userId } });

    if (!company) {
      throw new NotFoundException('Company not found');
    }

    const benefit = this.benefitRepository.create({
      ...dto,
      companyId: company.id,
      cost: parseInt(dto.cost, 10),
    });

    return this.benefitRepository.save(benefit);
  }
}
