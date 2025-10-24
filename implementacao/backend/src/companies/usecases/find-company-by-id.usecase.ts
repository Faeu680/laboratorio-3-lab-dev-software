import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CompanyResponseDto } from '../dto/company-response.dto';
import { CompanyEntity } from '../entities/company.entity';

@Injectable()
export class FindCompanyByIdUseCase {
  private readonly logger = new Logger(FindCompanyByIdUseCase.name);

  constructor(
    @InjectRepository(CompanyEntity)
    private readonly companyRepository: Repository<CompanyEntity>
  ) {}

  async execute(companyId: string): Promise<CompanyResponseDto> {
    const company = await this.companyRepository.findOne({
      where: { id: companyId },
      relations: ['user'],
    });

    if (!company) {
      throw new NotFoundException('Empresa não encontrada');
    }

    return {
      id: company.id,
      name: company.user.name,
      email: company.user.email,
      cnpj: company.cnpj,
      description: company.description,
    };
  }
}
