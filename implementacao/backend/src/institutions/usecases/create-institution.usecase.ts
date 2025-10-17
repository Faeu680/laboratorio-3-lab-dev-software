import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateInstitutionDto } from '../dto/create-institution.dto';
import { InstitutionEntity } from '../entities/institution.entity';

@Injectable()
export class CreateInstitutionUseCase {
  constructor(
    @InjectRepository(InstitutionEntity)
    private readonly institutionRepository: Repository<InstitutionEntity>,
  ) {}

  async execute(dto: CreateInstitutionDto): Promise<InstitutionEntity> {
    const institution = this.institutionRepository.create(dto);
    return this.institutionRepository.save(institution);
  }
}
