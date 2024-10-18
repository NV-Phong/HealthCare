import { Controller, Get, UseGuards } from '@nestjs/common';
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
}
