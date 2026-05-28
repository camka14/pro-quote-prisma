CREATE TABLE IF NOT EXISTS "ClientApiEndpoint" (
  id TEXT NOT NULL,
  "clientApiConfigId" TEXT NOT NULL,
  "clientDomain" TEXT NOT NULL,
  name TEXT NOT NULL,
  "apiUrl" TEXT NOT NULL,
  "apiSchema" JSONB,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "ClientApiEndpoint_pkey" PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS "ClientApiEndpoint_clientApiConfigId_idx"
  ON "ClientApiEndpoint"("clientApiConfigId");

CREATE INDEX IF NOT EXISTS "ClientApiEndpoint_clientDomain_idx"
  ON "ClientApiEndpoint"("clientDomain");

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'ClientApiEndpoint_clientApiConfigId_fkey'
  ) THEN
    ALTER TABLE "ClientApiEndpoint"
      ADD CONSTRAINT "ClientApiEndpoint_clientApiConfigId_fkey"
      FOREIGN KEY ("clientApiConfigId") REFERENCES "ClientApiConfig"(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;

INSERT INTO "ClientApiEndpoint" (
  id,
  "clientApiConfigId",
  "clientDomain",
  name,
  "apiUrl",
  "apiSchema",
  "createdAt",
  "updatedAt"
)
SELECT
  id || '_default_endpoint',
  id,
  domain,
  'Default endpoint',
  "apiUrl",
  "apiSchema",
  "createdAt",
  "updatedAt"
FROM "ClientApiConfig"
WHERE "apiUrl" IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM "ClientApiEndpoint" endpoint
    WHERE endpoint."clientApiConfigId" = "ClientApiConfig".id
  );

ALTER TABLE "ClientWebhookSecret"
  ADD COLUMN IF NOT EXISTS "clientApiEndpointId" TEXT;

CREATE INDEX IF NOT EXISTS "ClientWebhookSecret_clientApiEndpointId_idx"
  ON "ClientWebhookSecret"("clientApiEndpointId");

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'ClientWebhookSecret_clientApiEndpointId_fkey'
  ) THEN
    ALTER TABLE "ClientWebhookSecret"
      ADD CONSTRAINT "ClientWebhookSecret_clientApiEndpointId_fkey"
      FOREIGN KEY ("clientApiEndpointId") REFERENCES "ClientApiEndpoint"(id)
      ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;

UPDATE "ClientWebhookSecret" secret
SET "clientApiEndpointId" = endpoint.id
FROM "ClientApiEndpoint" endpoint
WHERE secret."clientApiEndpointId" IS NULL
  AND secret."clientApiConfigId" = endpoint."clientApiConfigId"
  AND endpoint.name = 'Default endpoint';

ALTER TABLE "ClientAllowedEmail"
  ADD COLUMN IF NOT EXISTS "clientApiEndpointId" TEXT;

CREATE INDEX IF NOT EXISTS "ClientAllowedEmail_clientApiEndpointId_idx"
  ON "ClientAllowedEmail"("clientApiEndpointId");

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'ClientAllowedEmail_clientApiEndpointId_fkey'
  ) THEN
    ALTER TABLE "ClientAllowedEmail"
      ADD CONSTRAINT "ClientAllowedEmail_clientApiEndpointId_fkey"
      FOREIGN KEY ("clientApiEndpointId") REFERENCES "ClientApiEndpoint"(id)
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;

ALTER TABLE "ClientAllowedEmail"
  DROP CONSTRAINT IF EXISTS "ClientAllowedEmail_clientDomain_email_key";

DROP INDEX IF EXISTS "ClientAllowedEmail_clientDomain_email_key";

CREATE UNIQUE INDEX IF NOT EXISTS "ClientAllowedEmail_domain_email_any_endpoint_key"
  ON "ClientAllowedEmail"("clientDomain", email)
  WHERE "clientApiEndpointId" IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS "ClientAllowedEmail_domain_email_endpoint_key"
  ON "ClientAllowedEmail"("clientDomain", email, "clientApiEndpointId")
  WHERE "clientApiEndpointId" IS NOT NULL;

ALTER TABLE "DomainTransfer"
  ADD COLUMN IF NOT EXISTS "clientApiEndpointId" TEXT;

CREATE INDEX IF NOT EXISTS "DomainTransfer_clientApiEndpointId_idx"
  ON "DomainTransfer"("clientApiEndpointId");

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'DomainTransfer_clientApiEndpointId_fkey'
  ) THEN
    ALTER TABLE "DomainTransfer"
      ADD CONSTRAINT "DomainTransfer_clientApiEndpointId_fkey"
      FOREIGN KEY ("clientApiEndpointId") REFERENCES "ClientApiEndpoint"(id)
      ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;
