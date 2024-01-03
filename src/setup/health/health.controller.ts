import { Controller, Get } from '@nestjs/common';
import {
  HealthCheckService,
  HealthCheck,
  DiskHealthIndicator,
  MemoryHealthIndicator,
} from '@nestjs/terminus';
import { version } from '../../../package.json';

@Controller({
  path: 'health',
  version: '',
})
export class HealthController {
  constructor(
    private health: HealthCheckService,
    private disk: DiskHealthIndicator,
    private memory: MemoryHealthIndicator,
  ) {}

  @Get()
  @HealthCheck()
  async check() {
    try {
      const result = await this.health.check([
        () =>
          this.disk.checkStorage('disk', { path: '/', thresholdPercent: 90 }),
        () => this.memory.checkHeap('memory_heap', 500 * 1024 * 1024), // 500 MB
        () => this.memory.checkRSS('memory_rss', 500 * 1024 * 1024), // 500 MB
      ]);
      return {
        version,
        ...result,
      };
    } catch (error) {
      error.response = {
        version,
        ...error.response,
      };
      throw error;
    }
  }
}
