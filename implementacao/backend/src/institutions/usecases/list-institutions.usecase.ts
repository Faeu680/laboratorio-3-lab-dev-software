import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { InstitutionEntity } from '../entities/institution.entity';

@Injectable()
export class ListInstitutionsUseCase {
  constructor(
    @InjectRepository(InstitutionEntity)
    private readonly institutionRepository: Repository<InstitutionEntity>,
  ) {}

  async execute(): Promise<InstitutionEntity[]> {
    return this.institutionRepository.find();
  }
}
