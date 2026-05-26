-- CreateTable
CREATE TABLE IF NOT EXISTS "ClientWebhookSecret" (
    "id" TEXT NOT NULL,
    "clientApiConfigId" TEXT NOT NULL,
    "clientDomain" TEXT NOT NULL,
    "secret" TEXT NOT NULL,
    "secretHash" TEXT NOT NULL,
    "secretLast6" TEXT NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ClientWebhookSecret_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "ClientWebhookSecret_secretHash_key" UNIQUE ("secretHash")
);

-- Backfill the new table from the previous single-secret columns.
INSERT INTO "ClientWebhookSecret" (
    "id",
    "clientApiConfigId",
    "clientDomain",
    "secret",
    "secretHash",
    "secretLast6",
    "createdAt",
    "updatedAt"
)
SELECT
    CONCAT('legacy_', md5(id || "webhookSecretHash")),
    id,
    domain,
    "webhookSecret",
    "webhookSecretHash",
    COALESCE("webhookSecretLast6", right("webhookSecret", 6)),
    COALESCE("webhookSecretCreatedAt", "createdAt"),
    "updatedAt"
FROM "ClientApiConfig"
WHERE "webhookSecret" IS NOT NULL
  AND "webhookSecretHash" IS NOT NULL
ON CONFLICT ("secretHash") DO NOTHING;

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "ClientWebhookSecret_secretHash_key"
    ON "ClientWebhookSecret"("secretHash");

CREATE INDEX IF NOT EXISTS "ClientWebhookSecret_clientApiConfigId_idx"
    ON "ClientWebhookSecret"("clientApiConfigId");

CREATE INDEX IF NOT EXISTS "ClientWebhookSecret_clientDomain_idx"
    ON "ClientWebhookSecret"("clientDomain");

CREATE INDEX IF NOT EXISTS "ClientWebhookSecret_deletedAt_idx"
    ON "ClientWebhookSecret"("deletedAt");

-- AddForeignKey
DO $$
BEGIN
    ALTER TABLE "ClientWebhookSecret"
        ADD CONSTRAINT "ClientWebhookSecret_clientApiConfigId_fkey"
        FOREIGN KEY ("clientApiConfigId")
        REFERENCES "ClientApiConfig"("id")
        ON DELETE CASCADE
        ON UPDATE CASCADE;
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;
