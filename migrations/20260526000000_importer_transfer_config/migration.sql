-- CreateTable
CREATE TABLE IF NOT EXISTS "ClientApiConfig" (
    "id" TEXT NOT NULL,
    "domain" TEXT NOT NULL,
    "apiUrl" TEXT NOT NULL,
    "apiKey" TEXT,
    "apiSchema" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClientApiConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "ClientAllowedEmail" (
    "id" TEXT NOT NULL,
    "clientApiConfigId" TEXT,
    "clientDomain" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "label" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClientAllowedEmail_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "TransferScript" (
    "id" TEXT NOT NULL,
    "clientApiConfigId" TEXT,
    "clientDomain" TEXT NOT NULL,
    "sourceDomain" TEXT NOT NULL,
    "cacheKey" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "source" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TransferScript_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "ClientApiConfig_domain_key" ON "ClientApiConfig"("domain");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientApiConfig_domain_idx" ON "ClientApiConfig"("domain");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "ClientAllowedEmail_clientDomain_email_key" ON "ClientAllowedEmail"("clientDomain", "email");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientAllowedEmail_clientApiConfigId_idx" ON "ClientAllowedEmail"("clientApiConfigId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientAllowedEmail_clientDomain_idx" ON "ClientAllowedEmail"("clientDomain");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "ClientAllowedEmail_email_idx" ON "ClientAllowedEmail"("email");

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "TransferScript_clientDomain_sourceDomain_cacheKey_key" ON "TransferScript"("clientDomain", "sourceDomain", "cacheKey");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "TransferScript_clientApiConfigId_idx" ON "TransferScript"("clientApiConfigId");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "TransferScript_clientDomain_idx" ON "TransferScript"("clientDomain");

-- CreateIndex
CREATE INDEX IF NOT EXISTS "TransferScript_sourceDomain_idx" ON "TransferScript"("sourceDomain");

-- AddForeignKey
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ClientAllowedEmail_clientApiConfigId_fkey'
    ) THEN
        ALTER TABLE "ClientAllowedEmail"
        ADD CONSTRAINT "ClientAllowedEmail_clientApiConfigId_fkey"
        FOREIGN KEY ("clientApiConfigId") REFERENCES "ClientApiConfig"("id")
        ON DELETE SET NULL ON UPDATE CASCADE;
    END IF;
END $$;

-- AddForeignKey
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'TransferScript_clientApiConfigId_fkey'
    ) THEN
        ALTER TABLE "TransferScript"
        ADD CONSTRAINT "TransferScript_clientApiConfigId_fkey"
        FOREIGN KEY ("clientApiConfigId") REFERENCES "ClientApiConfig"("id")
        ON DELETE SET NULL ON UPDATE CASCADE;
    END IF;
END $$;
