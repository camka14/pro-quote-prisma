-- CreateTable
CREATE TABLE "WebExtensionExport" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "userEmail" TEXT NOT NULL,
    "siteOrigin" TEXT NOT NULL,
    "runId" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "startedAt" TIMESTAMP(3) NOT NULL,
    "endedAt" TIMESTAMP(3),
    "pagesSeen" INTEGER NOT NULL,
    "groupCount" INTEGER NOT NULL,
    "recordCount" INTEGER NOT NULL,
    "capture" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "WebExtensionExport_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "WebExtensionExport_userId_idx" ON "WebExtensionExport"("userId");

-- CreateIndex
CREATE INDEX "WebExtensionExport_userEmail_idx" ON "WebExtensionExport"("userEmail");

-- CreateIndex
CREATE INDEX "WebExtensionExport_siteOrigin_idx" ON "WebExtensionExport"("siteOrigin");

-- CreateIndex
CREATE INDEX "WebExtensionExport_runId_idx" ON "WebExtensionExport"("runId");

-- AddForeignKey
ALTER TABLE "WebExtensionExport" ADD CONSTRAINT "WebExtensionExport_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
