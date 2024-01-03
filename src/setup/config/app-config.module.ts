import { Logger, Module, OnModuleInit } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import configuration from './configuration';

@Module({
  imports: [
    ConfigModule.forRoot({
      cache: true,
      isGlobal: true,
      load: [configuration],
    }),
  ],
})
export class AppConfigModule implements OnModuleInit {
  private logger = new Logger(AppConfigModule.name);
  constructor(private readonly configs: ConfigService) {}
  onModuleInit() {
    this.logger.debug('Configurations loaded:');
    this.logger.debug(this.configs);
  }
}
