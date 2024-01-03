import * as dotenv from 'dotenv-safe';
dotenv.config({});
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ApiDocsModule } from './setup/docs/api-docs.module';
import { ResponseTransformInterceptor } from './common/interceptors/response-transform.interceptor';
import { HttpExceptionFilter } from './common/exception-filters/http-exception.filter';
import configuration from './setup/config/configuration';

const LOG_LEVEL_MAP = {
  error: ['fatal', 'error', 'warn'],
  debug: ['log', 'fatal', 'error', 'warn', 'debug', 'verbose'],
  info: ['log', 'fatal', 'error', 'warn'],
};

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger:
      LOG_LEVEL_MAP[(process.env.LOG_LEVEL || '').toLowerCase()] ||
      LOG_LEVEL_MAP.info,
  });
  app.useGlobalInterceptors(new ResponseTransformInterceptor());
  await app.get(ApiDocsModule).setup(app);
  app.useGlobalFilters(new HttpExceptionFilter());
  await app.listen(configuration().port);
}
bootstrap();
