import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private logger = new Logger('Request');

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const host = context.switchToHttp();
    const req = host.getRequest();
    const res = host.getResponse();
    const now = Date.now();
    const log = `${req.method} ${req.url}`;
    this.logger.log(log);
    res.on('close', () => {
      if (res.statusCode < 400) {
        this.logger.log(
          `${log} --> ${res.statusCode} ${Date.now() - now}ms`,
          'Response',
        );
      } else {
        this.logger.error(
          `${log} --> ${res.statusCode} ${Date.now() - now}ms`,
          undefined,
          'Response',
        );
      }
    });
    return next.handle();
  }
}
