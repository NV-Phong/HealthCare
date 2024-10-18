import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { User, UserDocument } from 'src/schema/user.schema';

@Injectable()
export class AuthService {
   constructor(
      @InjectModel(User.name) private userModel: Model<UserDocument>,
      private jwtService: JwtService,
   ) {}

   async register(username: string, password: string) {
      const hashedPassword = await bcrypt.hash(password, 10);
      const newUser = new this.userModel({
         username,
         password: hashedPassword,
      });
      return newUser.save();
   }
}
