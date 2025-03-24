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
   // async login(username: string, password: string) {
   //    const user = await this.userModel.findOne({ username });
   //    if (user && (await bcrypt.compare(password, user.password))) {
   //       await this.diseaseService.importDiseasesFromJson('system-data/Disease.json');
   //       const payload = { username: user.username };
   //       return {
   //          access_token: this.jwtService.sign(payload),
   //       };
   //    }
   //    throw new Error('Invalid credentials');
   // }
   async login(username: string, password: string) {
      const user = await this.userModel.findOne({ username });
      if (user && (await bcrypt.compare(password, user.password))) {
         await this.diseaseService.importDiseasesFromJson('system-data/Disease.json');
         const accessToken = this.generateAccessToken(user);
         const refreshToken = this.generateRefreshToken(user);

         return {
            access_token: accessToken,
            refresh_token: refreshToken,
         };
      }
      throw new Error('Invalid credentials');
   }

   generateAccessToken(user: UserDocument) {
      const payload = { username: user.username };
      return this.jwtService.sign(payload, { secret: process.env.JWT_ACCESS_SECRET, expiresIn: '5m' });
   }

   generateRefreshToken(user: UserDocument) {
      const payload = { username: user.username };
      return this.jwtService.sign(payload, { secret: process.env.JWT_REFRESH_SECRET, expiresIn: '30d' });
   }

   // Phương thức để xác thực Refresh Token
   async validateRefreshToken(token: string) {
      try {
         const payload = this.jwtService.verify(token, { secret: process.env.JWT_REFRESH_SECRET });
         return await this.userModel.findOne({ username: payload.username });
      } catch (error) {
         throw new Error('Invalid refresh token');
      }
   }
}
