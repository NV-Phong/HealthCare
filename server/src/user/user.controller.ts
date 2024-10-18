import { Controller, Get, UseGuards } from '@nestjs/common';
import { User } from '../schema/user.schema';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
   constructor(private readonly userService: UserService) {}

   @Get()
   async getAllUsers(): Promise<User[]> {
      return this.userService.findAll();
   }
}
