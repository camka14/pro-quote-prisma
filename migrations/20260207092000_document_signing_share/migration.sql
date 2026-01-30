-- AlterTable
ALTER TABLE "Document" ADD COLUMN     "boldsignTemplateId" TEXT,
ADD COLUMN     "signerRoles" JSONB,
ADD COLUMN     "signingFields" JSONB,
ADD COLUMN     "signingRequired" BOOLEAN NOT NULL DEFAULT false;

-- CreateTable
CREATE TABLE "DocumentShareLink" (
    "id" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "createdById" TEXT NOT NULL,
    "recipients" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DocumentShareLink_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "DocumentShareLink_documentId_idx" ON "DocumentShareLink"("documentId");

-- CreateIndex
CREATE INDEX "DocumentShareLink_companyId_idx" ON "DocumentShareLink"("companyId");

-- CreateIndex
CREATE INDEX "DocumentShareLink_createdById_idx" ON "DocumentShareLink"("createdById");

-- AddForeignKey
ALTER TABLE "DocumentShareLink" ADD CONSTRAINT "DocumentShareLink_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentShareLink" ADD CONSTRAINT "DocumentShareLink_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentShareLink" ADD CONSTRAINT "DocumentShareLink_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
