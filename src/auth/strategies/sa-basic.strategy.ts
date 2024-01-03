import { BasicStrategy as Strategy } from 'passport-http';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class SABasicStrategy extends PassportStrategy(Strategy, 'sa-basic') {
  constructor(private readonly configService: ConfigService) {
    super({
      passReqToCallback: false,
    });
  }

  public validate = async (
    username: string,
    password: string,
  ): Promise<boolean> => {
    if (
      this.configService.get<string>('SERVICE_ACCOUNT_USERNAME') === username &&
      this.configService.get<string>('SERVICE_ACCOUNT_PASSWORD') === password
    ) {
      return true;
    }
    throw new UnauthorizedException();
  };
}
