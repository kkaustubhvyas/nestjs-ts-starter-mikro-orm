import { Injectable } from '@nestjs/common';
import { Redis } from 'ioredis';
import { AppConfigService } from '../../config/config.service';

@Injectable()
export class CacheRedisClient extends Redis {
  constructor(config: AppConfigService) {
    const { host, port, db } = config.getRedisCacheConfig();
    super(port, host, {
      db,
    });
  }
}
