ALTER TABLE "ImporterAccount"
  ADD COLUMN IF NOT EXISTS "emailVerificationTokenHash" TEXT,
  ADD COLUMN IF NOT EXISTS "emailVerificationTokenExpiresAt" TIMESTAMP(3),
  ADD COLUMN IF NOT EXISTS "emailVerificationSentAt" TIMESTAMP(3),
  ADD COLUMN IF NOT EXISTS "emailVerifiedAt" TIMESTAMP(3);

CREATE INDEX IF NOT EXISTS "ImporterAccount_emailVerificationTokenHash_idx"
  ON "ImporterAccount"("emailVerificationTokenHash");
