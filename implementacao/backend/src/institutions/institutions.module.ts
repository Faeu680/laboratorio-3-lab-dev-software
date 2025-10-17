import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { InstitutionEntity } from './entities/institution.entity';
import { InstitutionsController } from './institutions.controller';
import { CreateInstitutionUseCase } from './usecases/create-institution.usecase';
import { ListInstitutionsUseCase } from './usecases/list-institutions.usecase';

@Module({
  imports: [TypeOrmModule.forFeature([InstitutionEntity])],
  controllers: [InstitutionsController],
  providers: [CreateInstitutionUseCase, ListInstitutionsUseCase],
  exports: [TypeOrmModule],
})
export class InstitutionsModule {}
