ALTER TABLE "User"
  ADD COLUMN "loginFailedAttempts" INTEGER NOT NULL DEFAULT 0,
  ADD COLUMN "loginBlockedUntil" TIMESTAMP(3),
  ADD COLUMN "emailVerificationAttempts" INTEGER NOT NULL DEFAULT 0;

ALTER TABLE "ProjectShareInvite"
  ADD COLUMN "verificationAttempts" INTEGER NOT NULL DEFAULT 0;
