import { name, version } from '../../../package.json';

export default () => ({
  name,
  version: process.env.BUILD_TAG || version,
  port: parseInt(process.env.PORT, 10) || 3000,
  database: {
    mysql: {
      default: {
        connectionUri:
          process.env.DB_CONNECTION_URI ||
          'mysql://root:root@localhost:3306/boilerplate',
      },
    },
  },
  redis: {
    host: process.env.REDIS_HOST || '',
    port: Number(process.env.REDIS_PORT) || 6379,
    schedulerDb: Number(process.env.REDIS_DB) || 0,
    cacheDb: Number(process.env.REDIS_CACHE_DB) || 4,
  },
  apiDocs: {
    enable: process.env.ENABLE_DOCS === 'true',
  },
  log: {
    level: process.env.LOG_LEVEL || 'debug',
  },
});
