-- AlterTable
ALTER TABLE "ClientApiConfig"
    ADD COLUMN IF NOT EXISTS "webhookSecret" TEXT,
    ADD COLUMN IF NOT EXISTS "webhookSecretHash" TEXT,
    ADD COLUMN IF NOT EXISTS "webhookSecretLast6" TEXT,
    ADD COLUMN IF NOT EXISTS "webhookSecretCreatedAt" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "ClientApiKey"
    ADD COLUMN IF NOT EXISTS "keyLast6" TEXT;
