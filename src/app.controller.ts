import { BlobServiceClient } from '@azure/storage-blob';
import { Controller, Get } from '@nestjs/common';
import dotenv from 'dotenv';
import { AppService } from './app.service';
dotenv.config();

const AZURE_STORAGE_CONNECTION_STRING =
  process.env.AZURE_STORAGE_CONNECTION_STRING || '';
console.log(
  'AZURE_STORAGE_CONNECTION_STRING:',
  AZURE_STORAGE_CONNECTION_STRING,
);
const BLOB_SERVICE_CLIENT = BlobServiceClient.fromConnectionString(
  AZURE_STORAGE_CONNECTION_STRING,
);
const testContainerName = 'bicep-playground';
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  async getHello(): Promise<string> {
    const userContainer =
      BLOB_SERVICE_CLIENT.getContainerClient(testContainerName);
    await userContainer.createIfNotExists({
      access: 'blob',
    });
    return this.appService.getHello();
  }
}
