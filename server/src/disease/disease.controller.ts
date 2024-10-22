// disease.controller.ts
import { Controller, Get, Post, Body, UseGuards } from '@nestjs/common';
import { DiseaseService } from './disease.service';
import { Disease } from '../schema/disease.schema';
import { JwtAuthGuard } from 'src/configuration/jwt-auth.guard';

@Controller('disease')
@UseGuards(JwtAuthGuard)
export class DiseaseController {
    constructor(private readonly diseaseService: DiseaseService) {}

    @Post()
    async createDisease(@Body() diseaseData: Disease) {
        return this.diseaseService.createDisease(diseaseData);
    }

    @Get()
    async getAllDiseases() {
        return this.diseaseService.getAllDiseases();
    }
    @Get('import') // Endpoint để import dữ liệu từ JSON
    async import(): Promise<void> {
        await this.diseaseService.importDiseasesFromJson('system-data/Disease.Json'); // Đường dẫn đến file JSON
    }
}
