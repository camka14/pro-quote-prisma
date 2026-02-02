-- CreateTable
CREATE TABLE "ProjectShareInvite" (
    "id" TEXT NOT NULL,
    "projectId" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "createdById" TEXT NOT NULL,
    "recipientType" TEXT NOT NULL,
    "recipientId" TEXT,
    "recipientName" TEXT,
    "recipientEmail" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "canViewBudget" BOOLEAN NOT NULL DEFAULT false,
    "limitToLineItems" BOOLEAN NOT NULL DEFAULT true,
    "canViewTotals" BOOLEAN NOT NULL DEFAULT false,
    "canViewQuantities" BOOLEAN NOT NULL DEFAULT false,
    "budgetIds" TEXT[],
    "divisionIds" TEXT[],
    "lineItemIds" TEXT[],
    "verificationCodeHash" TEXT,
    "verificationCodeExpiresAt" TIMESTAMP(3),
    "verificationSentAt" TIMESTAMP(3),
    "verifiedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProjectShareInvite_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ProjectShareInvite_projectId_idx" ON "ProjectShareInvite"("projectId");

-- CreateIndex
CREATE INDEX "ProjectShareInvite_companyId_idx" ON "ProjectShareInvite"("companyId");

-- CreateIndex
CREATE INDEX "ProjectShareInvite_recipientEmail_idx" ON "ProjectShareInvite"("recipientEmail");

-- AddForeignKey
ALTER TABLE "ProjectShareInvite" ADD CONSTRAINT "ProjectShareInvite_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES "Project"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectShareInvite" ADD CONSTRAINT "ProjectShareInvite_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProjectShareInvite" ADD CONSTRAINT "ProjectShareInvite_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
