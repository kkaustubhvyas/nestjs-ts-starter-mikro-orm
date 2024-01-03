import { INestApplication, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

@Module({})
export class ApiDocsModule {
  async setup(app: INestApplication) {
    const configService = app.get(ConfigService);
    if (!configService.get('apiDocs.enable')) {
      return;
    }
    const { version, description } = await require('../../../package.json');
    const config = new DocumentBuilder()
      .setTitle(description)
      .setVersion(process.env.BUILD_TAG || version)
      .addBasicAuth()
      .build();
    const document = SwaggerModule.createDocument(app, config);
    SwaggerModule.setup('docs', app, document);
  }
}
