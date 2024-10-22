import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { User, UserDocument } from 'src/schema/user.schema';
import { DiseaseService } from 'src/disease/disease.service';
@Injectable()
export class AuthService {
   constructor(
      @InjectModel(User.name) private userModel: Model<UserDocument>,
      private jwtService: JwtService,
      private readonly diseaseService: DiseaseService

   ) {}

   async register(username: string, password: string) {
      const hashedPassword = await bcrypt.hash(password, 10);
      const newUser = new this.userModel({
         username,
         password: hashedPassword,
      });
      return newUser.save();
   }

   // Cần sửa lại phương thức Seed Data
   async login(username: string, password: string) {
      const user = await this.userModel.findOne({ username });
      if (user && (await bcrypt.compare(password, user.password))) {
         await this.diseaseService.importDiseasesFromJson('system-data/Disease.json');
         const payload = { username: user.username };
         return {
            access_token: this.jwtService.sign(payload),
         };
      }
      throw new Error('Invalid credentials');
   }
}
