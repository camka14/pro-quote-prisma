-- AlterTable
ALTER TABLE "DocumentTemplate" ADD COLUMN "boldsignTemplateId" TEXT;
ALTER TABLE "DocumentTemplate" ADD COLUMN "signerRoles" JSONB;

-- CreateTable
CREATE TABLE "DocumentSigningRequest" (
    "id" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,
    "templateId" TEXT,
    "boldsignTemplateId" TEXT,
    "boldsignDocumentId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DocumentSigningRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DocumentSigner" (
    "id" TEXT NOT NULL,
    "signingRequestId" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,
    "roleName" TEXT,
    "roleIndex" INTEGER,
    "signerName" TEXT NOT NULL,
    "signerEmail" TEXT NOT NULL,
    "signerUserId" TEXT,
    "signingOrder" INTEGER,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "signedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DocumentSigner_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "DocumentSigningRequest_documentId_idx" ON "DocumentSigningRequest"("documentId");

-- CreateIndex
CREATE INDEX "DocumentSigningRequest_boldsignDocumentId_idx" ON "DocumentSigningRequest"("boldsignDocumentId");

-- CreateIndex
CREATE INDEX "DocumentSigningRequest_createdById_idx" ON "DocumentSigningRequest"("createdById");

-- CreateIndex
CREATE INDEX "DocumentSigner_signingRequestId_idx" ON "DocumentSigner"("signingRequestId");

-- CreateIndex
CREATE INDEX "DocumentSigner_documentId_idx" ON "DocumentSigner"("documentId");

-- CreateIndex
CREATE INDEX "DocumentSigner_signerUserId_idx" ON "DocumentSigner"("signerUserId");

-- CreateIndex
CREATE INDEX "DocumentSigner_signerEmail_idx" ON "DocumentSigner"("signerEmail");

-- AddForeignKey
ALTER TABLE "DocumentSigningRequest" ADD CONSTRAINT "DocumentSigningRequest_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentSigningRequest" ADD CONSTRAINT "DocumentSigningRequest_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentSigner" ADD CONSTRAINT "DocumentSigner_signingRequestId_fkey" FOREIGN KEY ("signingRequestId") REFERENCES "DocumentSigningRequest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentSigner" ADD CONSTRAINT "DocumentSigner_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DocumentSigner" ADD CONSTRAINT "DocumentSigner_signerUserId_fkey" FOREIGN KEY ("signerUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
