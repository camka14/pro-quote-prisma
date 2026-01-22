-- Drop old team foreign key before renaming.
ALTER TABLE "Membership" DROP CONSTRAINT "Membership_teamId_fkey";

-- Rename teamId to roleId for memberships.
ALTER TABLE "Membership" RENAME COLUMN "teamId" TO "roleId";

-- Rename CompanyTeam table to Role.
ALTER TABLE "CompanyTeam" RENAME TO "Role";
ALTER TABLE "Role" RENAME CONSTRAINT "CompanyTeam_pkey" TO "Role_pkey";
ALTER TABLE "Role" RENAME CONSTRAINT "CompanyTeam_companyId_fkey" TO "Role_companyId_fkey";
ALTER INDEX "CompanyTeam_companyId_idx" RENAME TO "Role_companyId_idx";

-- Recreate foreign key for memberships to roles.
ALTER TABLE "Membership" ADD CONSTRAINT "Membership_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Add roleId to customers.
ALTER TABLE "Customer" ADD COLUMN "roleId" TEXT;
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("id") ON DELETE SET NULL ON UPDATE CASCADE;
CREATE INDEX "Customer_roleId_idx" ON "Customer"("roleId");

-- Create vendors table.
CREATE TABLE "Vendor" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,
    "roleId" TEXT,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Vendor_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "Vendor_companyId_idx" ON "Vendor"("companyId");
CREATE INDEX "Vendor_roleId_idx" ON "Vendor"("roleId");

ALTER TABLE "Vendor" ADD CONSTRAINT "Vendor_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "Vendor" ADD CONSTRAINT "Vendor_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "Vendor" ADD CONSTRAINT "Vendor_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Update shared links to target customers instead of recipient emails.
ALTER TABLE "SharedLink" ADD COLUMN "customerId" TEXT;
ALTER TABLE "SharedLink" DROP COLUMN "recipientEmails";
ALTER TABLE "SharedLink" DROP COLUMN "emailPermissions";
CREATE INDEX "SharedLink_customerId_idx" ON "SharedLink"("customerId");
ALTER TABLE "SharedLink" ADD CONSTRAINT "SharedLink_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE SET NULL ON UPDATE CASCADE;
