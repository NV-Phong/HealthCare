import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
   const app = await NestFactory.create(AppModule);

   // Tùy chỉnh cấu hình CORS
   app.enableCors({
      origin: '*', // Chỉ cho phép nguồn gốc cụ thể
      methods: 'GET,HEAD,PUT,PATCH,POST,DELETE', // Các phương thức được phép
      // allowedHeaders: 'Content-Type, Authorization', // Các header được phép
      credentials: true, // Cho phép cookies hoặc các thông tin xác thực
   });

   await app.listen(3000);
}
bootstrap();
