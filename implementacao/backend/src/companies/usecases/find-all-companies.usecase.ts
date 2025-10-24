import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CompanyResponseDto } from '../dto/company-response.dto';
import { CompanyEntity } from '../entities/company.entity';

@Injectable()
export class FindAllCompaniesUseCase {
  private readonly logger = new Logger(FindAllCompaniesUseCase.name);

  constructor(
    @InjectRepository(CompanyEntity)
    private readonly companyRepository: Repository<CompanyEntity>
  ) {}

  async execute(): Promise<CompanyResponseDto[]> {
    const companies = await this.companyRepository.find({
      relations: ['user'],
      order: { createdAt: 'DESC' },
    });

    return companies.map((company) => ({
      id: company.id,
      name: company.user.name,
      email: company.user.email,
      cnpj: company.cnpj,
      description: company.description,
    }));
  }
}
