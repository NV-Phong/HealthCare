import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { UserService } from '../user/user.service';

@Injectable()
export class RefreshTokenStrategy extends PassportStrategy(Strategy, 'jwt-refresh') {
    constructor(private readonly userService: UserService) {
        super({
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            secretOrKey: process.env.REFRESHKEY, // Cấu hình từ .env
        });
    }

    async validate(payload: any) {
        const user = await this.userService.findById(payload.id);
        if (!user) {
            throw new UnauthorizedException('Invalid token');
        }
        return user;
    }
}
