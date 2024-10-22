// disease.module.ts
import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Disease, DiseaseSchema } from '../schema/disease.schema';
import { DiseaseService } from './disease.service';
import { DiseaseController } from './disease.controller';

@Module({
    imports: [
        MongooseModule.forFeature([{ name: Disease.name, schema: DiseaseSchema }]),
    ],
    providers: [DiseaseService],
    controllers: [DiseaseController],
    exports:[DiseaseService],
})
export class DiseaseModule {}
