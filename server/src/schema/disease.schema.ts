// disease.model.ts
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type DiseaseDocument = Disease & Document;

@Schema()
export class Disease {
    @Prop({ required: true })
    Disease: string;

    @Prop({ type: [String], required: true })
    ListQuestion: string[];
}

export const DiseaseSchema = SchemaFactory.createForClass(Disease);
