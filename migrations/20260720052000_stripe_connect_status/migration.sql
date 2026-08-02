ALTER TABLE "StripeId"
ADD COLUMN "connectDetailsSubmitted" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN "connectChargesEnabled" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN "connectPayoutsEnabled" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN "connectDisabledReason" TEXT,
ADD COLUMN "connectCurrentlyDue" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
ADD COLUMN "connectPastDue" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
ADD COLUMN "connectStatusUpdatedAt" TIMESTAMP(3);
