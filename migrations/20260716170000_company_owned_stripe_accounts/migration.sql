-- Stripe Connect accounts are owned by companies, not by the user who happened
-- to start onboarding. Preserve older rows but detach duplicate company mappings
-- before enforcing one connected account per company.
DROP INDEX IF EXISTS "StripeId_userId_key";

WITH ranked AS (
  SELECT
    "id",
    ROW_NUMBER() OVER (
      PARTITION BY "companyId"
      ORDER BY "updatedAt" DESC, "createdAt" DESC, "id" DESC
    ) AS row_number
  FROM "StripeId"
  WHERE "companyId" IS NOT NULL
)
UPDATE "StripeId" AS stripe_id
SET "companyId" = NULL,
    "stripeAccountId" = NULL,
    "lastEvent" = NULL,
    "updatedAt" = CURRENT_TIMESTAMP
FROM ranked
WHERE stripe_id."id" = ranked."id"
  AND ranked.row_number > 1;

CREATE UNIQUE INDEX "StripeId_companyId_key"
  ON "StripeId"("companyId");

CREATE INDEX "StripeId_userId_idx" ON "StripeId"("userId");
