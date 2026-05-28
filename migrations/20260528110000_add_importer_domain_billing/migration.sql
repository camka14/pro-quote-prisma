ALTER TABLE "ClientApiConfig"
  ADD COLUMN IF NOT EXISTS "stripeCustomerId" TEXT,
  ADD COLUMN IF NOT EXISTS "stripeTransferPriceId" TEXT,
  ADD COLUMN IF NOT EXISTS "billingStatus" TEXT NOT NULL DEFAULT 'not_configured',
  ADD COLUMN IF NOT EXISTS "billingName" TEXT,
  ADD COLUMN IF NOT EXISTS "billingEmail" TEXT,
  ADD COLUMN IF NOT EXISTS "billingAddressLine1" TEXT,
  ADD COLUMN IF NOT EXISTS "billingAddressLine2" TEXT,
  ADD COLUMN IF NOT EXISTS "billingAddressCity" TEXT,
  ADD COLUMN IF NOT EXISTS "billingAddressState" TEXT,
  ADD COLUMN IF NOT EXISTS "billingAddressPostalCode" TEXT,
  ADD COLUMN IF NOT EXISTS "billingAddressCountry" TEXT,
  ADD COLUMN IF NOT EXISTS "billingTimezone" TEXT,
  ADD COLUMN IF NOT EXISTS "billingSetupCompletedAt" TIMESTAMP(3),
  ADD COLUMN IF NOT EXISTS "firstBillableTransferAt" TIMESTAMP(3),
  ADD COLUMN IF NOT EXISTS "nextBillingAt" TIMESTAMP(3),
  ADD COLUMN IF NOT EXISTS "billingBlockedAt" TIMESTAMP(3),
  ADD COLUMN IF NOT EXISTS "billingOverrideUntil" TIMESTAMP(3),
  ADD COLUMN IF NOT EXISTS "billingOverrideReason" TEXT,
  ADD COLUMN IF NOT EXISTS "latestStripeInvoiceId" TEXT,
  ADD COLUMN IF NOT EXISTS "latestStripeInvoiceStatus" TEXT,
  ADD COLUMN IF NOT EXISTS "latestInvoiceHostedUrl" TEXT;

CREATE UNIQUE INDEX IF NOT EXISTS "ClientApiConfig_stripeCustomerId_key"
  ON "ClientApiConfig"("stripeCustomerId")
  WHERE "stripeCustomerId" IS NOT NULL;

CREATE INDEX IF NOT EXISTS "ClientApiConfig_billingStatus_idx"
  ON "ClientApiConfig"("billingStatus");

CREATE INDEX IF NOT EXISTS "ClientApiConfig_nextBillingAt_idx"
  ON "ClientApiConfig"("nextBillingAt");

CREATE TABLE IF NOT EXISTS "DomainBillingInvoice" (
  id TEXT NOT NULL,
  "clientApiConfigId" TEXT NOT NULL,
  "clientDomain" TEXT NOT NULL,
  "stripeInvoiceId" TEXT,
  "stripeInvoiceItemId" TEXT,
  "stripePriceId" TEXT,
  "transferCount" INTEGER NOT NULL DEFAULT 0,
  "amountDueCents" INTEGER,
  currency TEXT NOT NULL DEFAULT 'usd',
  "billingPeriodStart" TIMESTAMP(3) NOT NULL,
  "billingPeriodEnd" TIMESTAMP(3) NOT NULL,
  status TEXT NOT NULL DEFAULT 'draft',
  "hostedInvoiceUrl" TEXT,
  "invoicePdfUrl" TEXT,
  "billedAt" TIMESTAMP(3),
  "paidAt" TIMESTAMP(3),
  "failedAt" TIMESTAMP(3),
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "DomainBillingInvoice_pkey" PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS "DomainBillingInvoice_stripeInvoiceId_key"
  ON "DomainBillingInvoice"("stripeInvoiceId")
  WHERE "stripeInvoiceId" IS NOT NULL;

CREATE INDEX IF NOT EXISTS "DomainBillingInvoice_clientApiConfigId_idx"
  ON "DomainBillingInvoice"("clientApiConfigId");

CREATE INDEX IF NOT EXISTS "DomainBillingInvoice_clientDomain_idx"
  ON "DomainBillingInvoice"("clientDomain");

CREATE INDEX IF NOT EXISTS "DomainBillingInvoice_status_idx"
  ON "DomainBillingInvoice"(status);

CREATE INDEX IF NOT EXISTS "DomainBillingInvoice_billedAt_idx"
  ON "DomainBillingInvoice"("billedAt");

CREATE TABLE IF NOT EXISTS "DomainTransfer" (
  id TEXT NOT NULL,
  "clientApiConfigId" TEXT NOT NULL,
  "clientDomain" TEXT NOT NULL,
  "sourceDomain" TEXT NOT NULL,
  "clientEmail" TEXT NOT NULL,
  "exportId" TEXT,
  "runId" TEXT,
  "transferredCount" INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL,
  "destinationStatus" INTEGER,
  "errorMessage" TEXT,
  billable BOOLEAN NOT NULL DEFAULT false,
  "domainBillingInvoiceId" TEXT,
  "stripeInvoiceId" TEXT,
  "stripeInvoiceItemId" TEXT,
  "billedAt" TIMESTAMP(3),
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "DomainTransfer_pkey" PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS "DomainTransfer_clientApiConfigId_idx"
  ON "DomainTransfer"("clientApiConfigId");

CREATE INDEX IF NOT EXISTS "DomainTransfer_clientDomain_idx"
  ON "DomainTransfer"("clientDomain");

CREATE INDEX IF NOT EXISTS "DomainTransfer_clientEmail_idx"
  ON "DomainTransfer"("clientEmail");

CREATE INDEX IF NOT EXISTS "DomainTransfer_sourceDomain_idx"
  ON "DomainTransfer"("sourceDomain");

CREATE INDEX IF NOT EXISTS "DomainTransfer_status_idx"
  ON "DomainTransfer"(status);

CREATE INDEX IF NOT EXISTS "DomainTransfer_billable_idx"
  ON "DomainTransfer"(billable);

CREATE INDEX IF NOT EXISTS "DomainTransfer_stripeInvoiceId_idx"
  ON "DomainTransfer"("stripeInvoiceId");

CREATE INDEX IF NOT EXISTS "DomainTransfer_createdAt_idx"
  ON "DomainTransfer"("createdAt");

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'DomainBillingInvoice_clientApiConfigId_fkey'
  ) THEN
    ALTER TABLE "DomainBillingInvoice"
      ADD CONSTRAINT "DomainBillingInvoice_clientApiConfigId_fkey"
      FOREIGN KEY ("clientApiConfigId") REFERENCES "ClientApiConfig"(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'DomainTransfer_clientApiConfigId_fkey'
  ) THEN
    ALTER TABLE "DomainTransfer"
      ADD CONSTRAINT "DomainTransfer_clientApiConfigId_fkey"
      FOREIGN KEY ("clientApiConfigId") REFERENCES "ClientApiConfig"(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'DomainTransfer_domainBillingInvoiceId_fkey'
  ) THEN
    ALTER TABLE "DomainTransfer"
      ADD CONSTRAINT "DomainTransfer_domainBillingInvoiceId_fkey"
      FOREIGN KEY ("domainBillingInvoiceId") REFERENCES "DomainBillingInvoice"(id)
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
