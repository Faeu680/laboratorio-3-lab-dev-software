import {
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserEntity } from 'src/auth/entities/user.entity';
import { Repository } from 'typeorm';
import { CompanyResponseDto } from '../dto/company-response.dto';
import { UpdateCompanyDto } from '../dto/update-company.dto';
import { CompanyEntity } from '../entities/company.entity';

@Injectable()
export class UpdateCompanyUseCase {
  private readonly logger = new Logger(UpdateCompanyUseCase.name);

  constructor(
    @InjectRepository(CompanyEntity)
    private readonly companyRepository: Repository<CompanyEntity>,
    @InjectRepository(UserEntity)
    private readonly userRepository: Repository<UserEntity>
  ) {}

  async execute(
    companyId: string,
    dto: UpdateCompanyDto
  ): Promise<CompanyResponseDto> {
    const company = await this.companyRepository.findOne({
      where: { id: companyId },
      relations: ['user'],
    });

    if (!company) {
      throw new NotFoundException('Empresa não encontrada');
    }

    // Verificar se o email já existe em outro usuário
    if (dto.email && dto.email !== company.user.email) {
      const existingUser = await this.userRepository.findOne({
        where: { email: dto.email },
      });

      if (existingUser) {
        throw new ConflictException('Email já está em uso');
      }
    }

    // Atualizar dados do usuário
    if (dto.name || dto.email) {
      await this.userRepository.update(company.userId, {
        name: dto.name || company.user.name,
        email: dto.email || company.user.email,
      });
    }

    // Atualizar dados da empresa
    await this.companyRepository.update(companyId, {
      cnpj: dto.cnpj || company.cnpj,
      description: dto.description !== undefined ? dto.description : company.description,
    });

    const updatedCompany = await this.companyRepository.findOne({
      where: { id: companyId },
      relations: ['user'],
    });

    this.logger.log(`Empresa atualizada: ${updatedCompany.user.name}`);

    return {
      id: updatedCompany.id,
      name: updatedCompany.user.name,
      email: updatedCompany.user.email,
      cnpj: updatedCompany.cnpj,
      description: updatedCompany.description,
    };
  }
}
