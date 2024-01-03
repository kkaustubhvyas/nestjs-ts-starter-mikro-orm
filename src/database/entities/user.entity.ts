import { BaseEntity, Entity, PrimaryKey, Property } from '@mikro-orm/core';

@Entity({})
export class User extends BaseEntity<User, 'id'> {
  @PrimaryKey({ type: 'number', autoincrement: true })
  id: number;

  @Property()
  username!: string;

  @Property()
  password!: string;
}
