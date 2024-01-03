import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AppService {
  constructor(private readonly config: ConfigService) {}
  getHello() {
    return {
      version: this.config.get('version'),
    };
  }
}
