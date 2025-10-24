import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { DataSource, Repository } from 'typeorm';
import { CompanyEntity } from '../entities/company.entity';
import { UserEntity } from 'src/auth/entities/user.entity';

@Injectable()
export class DeleteCompanyUseCase {
  private readonly logger = new Logger(DeleteCompanyUseCase.name);

  constructor(
    @InjectRepository(CompanyEntity)
    private readonly companyRepository: Repository<CompanyEntity>,
    private readonly dataSource: DataSource
  ) {}

  async execute(companyId: string): Promise<void> {
    const company = await this.companyRepository.findOne({
      where: { id: companyId },
      relations: ['user'],
    });

    if (!company) {
      throw new NotFoundException('Empresa não encontrada');
    }

    // Usar transação para garantir que ambos sejam deletados
    await this.dataSource.transaction(async (manager) => {
      await manager.delete(CompanyEntity, companyId);
      await manager.delete(UserEntity, company.userId);
    });

    this.logger.log(`Empresa deletada: ${company.user.name} (${companyId})`);
  }
}
