-- CreateTable
CREATE TABLE "CompanyTeam" (
    "id" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "permissions" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CompanyTeam_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "CompanyTeam_companyId_idx" ON "CompanyTeam"("companyId");

-- AddForeignKey
ALTER TABLE "CompanyTeam" ADD CONSTRAINT "CompanyTeam_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Membership" ADD CONSTRAINT "Membership_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "CompanyTeam"("id") ON DELETE SET NULL ON UPDATE CASCADE;
