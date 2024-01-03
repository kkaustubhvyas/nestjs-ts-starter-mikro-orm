import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class SABasicAuthGuard extends AuthGuard('sa-basic') {}
