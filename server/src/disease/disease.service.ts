// disease.service.ts
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Disease, DiseaseDocument } from '../schema/disease.schema';
import * as fs from 'fs';
@Injectable()
export class DiseaseService {
    constructor(@InjectModel(Disease.name) private diseaseModel: Model<DiseaseDocument>) {}

    async createDisease(diseaseData: Disease): Promise<Disease> {
        const newDisease = new this.diseaseModel(diseaseData);
        return newDisease.save();
    }

    async getAllDiseases(): Promise<Disease[]> {
        return this.diseaseModel.find().exec();
    }
   
    async importDiseasesFromJson(filePath: string): Promise<void> {
        // Đọc dữ liệu từ file JSON
        const jsonData = fs.readFileSync(filePath, 'utf8');
        const diseases = JSON.parse(jsonData);

        // Kiểm tra xem dữ liệu đã tồn tại chưa
        const existingDiseases = await this.diseaseModel.find().exec();
        if (existingDiseases.length === 0) {
            // Chèn dữ liệu vào MongoDB nếu chưa có
            await this.diseaseModel.insertMany(diseases);
            console.log('Dữ liệu đã được chèn vào MongoDB thành công!');
        } else {
            console.log('Dữ liệu đã tồn tại, không cần chèn.');
        }
}
}
