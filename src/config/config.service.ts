import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AppConfigService {
  private logger = new Logger(AppConfigService.name);

  constructor(private configService: ConfigService) {
    this.logger.debug(JSON.stringify(configService, undefined, 2));
  }

  getRedisCacheConfig() {
    return {
      host: this.configService.getOrThrow('redis.host'),
      port: this.configService.getOrThrow('redis.port'),
      db: this.configService.getOrThrow('redis.cacheDb'),
    };
  }
}
