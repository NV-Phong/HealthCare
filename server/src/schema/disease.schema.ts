// disease.schema.ts
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type DiseaseDocument = Disease & Document;

@Schema()
export class Disease {
   @Prop({ required: true })
   Disease: string;

   @Prop({ type: Map, of: String, required: true })
   ListQuestion: Record<string, string>;
}

export const DiseaseSchema = SchemaFactory.createForClass(Disease);
