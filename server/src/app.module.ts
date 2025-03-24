import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { ConfigModule } from '@nestjs/config';
import { DiseaseModule } from './disease/disease.module';

@Module({
   imports: [
      ConfigModule.forRoot(),
      MongooseModule.forRoot(process.env.DATABASE),
      AuthModule,
      UserModule,
      DiseaseModule,
   ],
   controllers: [AppController],
   providers: [AppService],
})
export class AppModule {}
