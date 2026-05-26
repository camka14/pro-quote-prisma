-- EnableFunction
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- AlterTable
ALTER TABLE "ClientApiConfig"
    ADD COLUMN IF NOT EXISTS "domainUuid" UUID DEFAULT gen_random_uuid();

ALTER TABLE "ClientApiConfig"
    ALTER COLUMN "domainUuid" SET DEFAULT gen_random_uuid();

UPDATE "ClientApiConfig"
SET "domainUuid" = gen_random_uuid()
WHERE "domainUuid" IS NULL;

ALTER TABLE "ClientApiConfig"
    ALTER COLUMN "domainUuid" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "ClientApiConfig_domainUuid_key"
    ON "ClientApiConfig"("domainUuid");
