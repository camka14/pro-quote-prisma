ALTER TABLE "SharedLink"
  ADD COLUMN "verificationCodeHash" TEXT,
  ADD COLUMN "verificationCodeExpiresAt" TIMESTAMP(3),
  ADD COLUMN "verificationCodeSentAt" TIMESTAMP(3),
  ADD COLUMN "verificationAttempts" INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN "verifiedAt" TIMESTAMP(3);

ALTER TABLE "DocumentShareLink"
  ADD COLUMN "verificationCodeHash" TEXT,
  ADD COLUMN "verificationCodeExpiresAt" TIMESTAMP(3),
  ADD COLUMN "verificationCodeSentAt" TIMESTAMP(3),
  ADD COLUMN "verificationAttempts" INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN "verifiedAt" TIMESTAMP(3);
