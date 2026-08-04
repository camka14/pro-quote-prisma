-- AlterTable
ALTER TABLE "Subscription" ADD COLUMN "paymentMethodReady" BOOLEAN NOT NULL DEFAULT false;

-- Revoke cached trial access until Stripe confirms that a payment method exists.
UPDATE "User"
SET "subscriptionStatus" = 'inactive', "subscriptionId" = NULL
WHERE "subscriptionStatus" = 'trialing';
