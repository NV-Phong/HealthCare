import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { User, UserSchema } from 'src/schema/user.schema';
import { UserService } from 'src/user/user.service';
import { JwtStrategy } from 'src/configuration/jwt.strategy';

@Module({
   imports: [
      MongooseModule.forFeature([{ name: User.name, schema: UserSchema }]),
      JwtModule.register({
         secret: 'Ng7633nxVa2nPh9ngM8nhDD72cs',
         signOptions: { expiresIn: '7d' },
      }),
   ],
   providers: [AuthService,JwtStrategy, UserService],
   controllers: [AuthController],
})
export class AuthModule {}
