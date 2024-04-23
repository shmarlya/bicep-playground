import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  console.log('App works');
  console.log('process.env', process.env);
  const PORT = Number(process.env.PORT) || 3000;
  await app.listen(PORT);
}
bootstrap();
