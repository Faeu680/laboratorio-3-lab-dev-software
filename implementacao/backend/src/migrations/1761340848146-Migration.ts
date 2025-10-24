import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1761340848146 implements MigrationInterface {
    name = 'Migration1761340848146'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TYPE "public"."user_entity_role_enum" RENAME TO "user_entity_role_enum_old"`);
        await queryRunner.query(`CREATE TYPE "public"."user_entity_role_enum" AS ENUM('ADMIN', 'STUDENT', 'TEACHER', 'COMPANY')`);
        await queryRunner.query(`ALTER TABLE "user_entity" ALTER COLUMN "role" TYPE "public"."user_entity_role_enum" USING "role"::"text"::"public"."user_entity_role_enum"`);
        await queryRunner.query(`DROP TYPE "public"."user_entity_role_enum_old"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."user_entity_role_enum_old" AS ENUM('STUDENT', 'TEACHER', 'COMPANY')`);
        await queryRunner.query(`ALTER TABLE "user_entity" ALTER COLUMN "role" TYPE "public"."user_entity_role_enum_old" USING "role"::"text"::"public"."user_entity_role_enum_old"`);
        await queryRunner.query(`DROP TYPE "public"."user_entity_role_enum"`);
        await queryRunner.query(`ALTER TYPE "public"."user_entity_role_enum_old" RENAME TO "user_entity_role_enum"`);
    }

}
