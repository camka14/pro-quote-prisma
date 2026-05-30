ALTER TABLE "ClientAllowedEmail"
  ADD COLUMN IF NOT EXISTS "pluginAccessTokenHash" TEXT,
  ADD COLUMN IF NOT EXISTS "pluginAccessTokenLast6" TEXT,
  ADD COLUMN IF NOT EXISTS "pluginAccessTokenCreatedAt" TIMESTAMP(3),
  ADD COLUMN IF NOT EXISTS "pluginAccessTokenLastUsedAt" TIMESTAMP(3);

CREATE UNIQUE INDEX IF NOT EXISTS "ClientAllowedEmail_pluginAccessTokenHash_key"
  ON "ClientAllowedEmail"("pluginAccessTokenHash")
  WHERE "pluginAccessTokenHash" IS NOT NULL;
