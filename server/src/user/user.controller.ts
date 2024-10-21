import { Body, Controller, Get, Param, Put, UseGuards } from '@nestjs/common';
import { User } from '../schema/user.schema';
import { UserService } from './user.service';
import { JwtAuthGuard } from 'src/configuration/jwt-auth.guard';

@Controller('user')
// @UseGuards(JwtAuthGuard)
export class UserController {
   constructor(private readonly userService: UserService) {}

   // For Admin
   @Get()
   async getAllUsers(): Promise<User[]> {
      return this.userService.findAll();
   }

   // Update
   @Put(':id')
    async updateUser(@Param('id') userId: string, @Body() updateData: Partial<User>) {
        return this.userService.updateUser(userId, updateData);
    }

}
