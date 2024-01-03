import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AppConfigModule } from './config/config.module';
import { ApiDocsModule } from './setup/docs/api-docs.module';
import { UsersController } from './controllers/user.controller';
import { DatabaseModule } from './database/database.module';
import { RedisModule } from './common/redis/redis.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    AuthModule,
    RedisModule,
    DatabaseModule,
    ApiDocsModule,
    AppConfigModule,
  ],
  controllers: [AppController, UsersController],
  providers: [AppService],
})
export class AppModule {}
