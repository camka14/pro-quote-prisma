CREATE TABLE IF NOT EXISTS "ReviewTransferCapture" (
  id TEXT NOT NULL,
  slug TEXT NOT NULL,
  payload JSONB NOT NULL,
  "destinationDomain" TEXT,
  "sourceDomain" TEXT,
  "clientEmail" TEXT,
  "exportId" TEXT,
  "runId" TEXT,
  "transferredCount" INTEGER NOT NULL DEFAULT 0,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "ReviewTransferCapture_pkey" PRIMARY KEY (id)
);

CREATE UNIQUE INDEX IF NOT EXISTS "ReviewTransferCapture_slug_key"
  ON "ReviewTransferCapture"(slug);

CREATE INDEX IF NOT EXISTS "ReviewTransferCapture_slug_idx"
  ON "ReviewTransferCapture"(slug);
