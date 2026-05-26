-- CreateTable
CREATE TABLE IF NOT EXISTS "ImporterAccount" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ImporterAccount_pkey" PRIMARY KEY ("id")
);

-- AlterTable
ALTER TABLE "ClientApiConfig"
    ADD COLUMN IF NOT EXISTS "ownerAccountId" TEXT,
    ADD COLUMN IF NOT EXISTS "verificationEmail" TEXT,
    ADD COLUMN IF NOT EXISTS "verificationTokenHash" TEXT,
    ADD COLUMN IF NOT EXISTS "verificationTokenExpiresAt" TIMESTAMP(3),
    ADD COLUMN IF NOT EXISTS "verificationSentAt" TIMESTAMP(3),
    ADD COLUMN IF NOT EXISTS "verifiedAt" TIMESTAMP(3);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ClientApiKey" (
    "id" TEXT NOT NULL,
    "clientApiConfigId" TEXT NOT NULL,
    "clientDomain" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "keyPrefix" TEXT NOT NULL,
    "keyHash" TEXT NOT NULL,
    "scopes" JSONB NOT NULL,
    "lastUsedAt" TIMESTAMP(3),
    "revokedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClientApiKey_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "ImporterAccount_email_key" ON "ImporterAccount"("email");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ImporterAccount_email_idx" ON "ImporterAccount"("email");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientApiConfig_ownerAccountId_idx" ON "ClientApiConfig"("ownerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "ClientApiKey_keyHash_key" ON "ClientApiKey"("keyHash");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientApiKey_clientApiConfigId_idx" ON "ClientApiKey"("clientApiConfigId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientApiKey_clientDomain_idx" ON "ClientApiKey"("clientDomain");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientApiKey_keyPrefix_idx" ON "ClientApiKey"("keyPrefix");

-- AddForeignKey
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ClientApiConfig_ownerAccountId_fkey'
    ) THEN
        ALTER TABLE "ClientApiConfig"
        ADD CONSTRAINT "ClientApiConfig_ownerAccountId_fkey"
        FOREIGN KEY ("ownerAccountId") REFERENCES "ImporterAccount"("id")
        ON DELETE SET NULL ON UPDATE CASCADE;
    END IF;
END $$;

-- AddForeignKey
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ClientApiKey_clientApiConfigId_fkey'
    ) THEN
        ALTER TABLE "ClientApiKey"
        ADD CONSTRAINT "ClientApiKey_clientApiConfigId_fkey"
        FOREIGN KEY ("clientApiConfigId") REFERENCES "ClientApiConfig"("id")
        ON DELETE CASCADE ON UPDATE CASCADE;
    END IF;
END $$;
