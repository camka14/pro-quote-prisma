-- AlterTable
ALTER TABLE "ClientApiConfig"
    ADD COLUMN IF NOT EXISTS "pendingDomain" TEXT,
    ADD COLUMN IF NOT EXISTS "pendingVerificationEmail" TEXT,
    ADD COLUMN IF NOT EXISTS "pendingVerificationTokenHash" TEXT,
    ADD COLUMN IF NOT EXISTS "pendingVerificationTokenExpiresAt" TIMESTAMP(3),
    ADD COLUMN IF NOT EXISTS "pendingVerificationSentAt" TIMESTAMP(3);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "ClientApiConfig_pendingDomain_key"
    ON "ClientApiConfig"("pendingDomain");
