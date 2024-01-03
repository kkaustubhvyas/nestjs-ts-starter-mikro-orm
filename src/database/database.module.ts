import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppConfigModule } from '../setup/config/app-config.module';
import { MikroOrmModule } from '@mikro-orm/nestjs';

@Global()
@Module({
  imports: [
    MikroOrmModule.forRoot({
      entities: ['./dist/src/database/entities'],
      entitiesTs: ['./src/database/entities'],
    }),
  ],
})
export class DatabaseModule {}
