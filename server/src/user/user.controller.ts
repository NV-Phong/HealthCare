import {
   Body,
   Controller,
   Get,
   Param,
   Put,
   Req,
   UseGuards,
} from '@nestjs/common';
import { User } from '../schema/user.schema';
import { UserService } from './user.service';
import { JwtAuthGuard } from 'src/configuration/jwt-auth.guard';
import { Request } from 'express';

@Controller('user')
@UseGuards(JwtAuthGuard)
export class UserController {
   constructor(private readonly userService: UserService) {}

   // For Admin
   @Get()
   async getAllUsers(): Promise<User[]> {
      return this.userService.findAll();
   }

   // Update
   @Put(':id')
   async updateUser(
      @Param('id') userId: string,
      @Body() updateData: Partial<User>,
   ) {
      return this.userService.updateUser(userId, updateData);
   }

   @Get('profile-completion/:id')
   async getProfileCompletion(@Param('id') id: string) {
      const user = await this.userService.findById(id);
      if (!user) {
         return { message: 'User not found' };
      }
      const completion =
         await this.userService.calculateProfileCompletion(user);
      return { completion };
   }

   @Get('profile-completion')
   async getProfileCompletionbytoken(@Req() req) {
      const user = req.user; // user đã được lấy từ `token` thông qua JwtAuthGuard
      const completion =
         await this.userService.calculateProfileCompletion(user);
      return { completion };
   }
}
