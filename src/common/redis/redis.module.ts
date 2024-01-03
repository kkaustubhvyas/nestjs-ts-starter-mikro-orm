import { Global, Module } from '@nestjs/common';
import { CacheRedisClient } from './cache-redis.service';

@Global()
@Module({
  providers: [CacheRedisClient],
  exports: [CacheRedisClient],
})
export class RedisModule {}
