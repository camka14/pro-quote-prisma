CREATE TABLE "RateLimitBucket" (
    "keyHash" TEXT NOT NULL,
    "windowStart" TIMESTAMP(3) NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "count" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "RateLimitBucket_pkey" PRIMARY KEY ("keyHash", "windowStart")
);

CREATE TABLE "DemoTokenNonce" (
    "nonce" TEXT NOT NULL,
    "ipHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DemoTokenNonce_pkey" PRIMARY KEY ("nonce")
);

CREATE INDEX "RateLimitBucket_keyHash_expiresAt_idx" ON "RateLimitBucket"("keyHash", "expiresAt");
CREATE INDEX "RateLimitBucket_expiresAt_idx" ON "RateLimitBucket"("expiresAt");
CREATE INDEX "DemoTokenNonce_expiresAt_idx" ON "DemoTokenNonce"("expiresAt");
