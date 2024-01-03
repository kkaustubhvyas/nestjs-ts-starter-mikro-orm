import { Module } from '@nestjs/common';
import { SABasicAuthGuard } from './guards/sa-basic.guard';
import { SABasicStrategy } from './strategies/sa-basic.strategy';

@Module({
  imports: [],
  providers: [SABasicAuthGuard, SABasicStrategy],
  exports: [SABasicStrategy],
})
export class AuthModule {}
