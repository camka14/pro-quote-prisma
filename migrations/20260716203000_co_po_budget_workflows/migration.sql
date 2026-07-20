-- CreateEnum
CREATE TYPE "BudgetLifecycleStatus" AS ENUM ('DRAFT', 'ACTIVE', 'CLOSED');

-- CreateEnum
CREATE TYPE "BudgetVersionKind" AS ENUM ('SAVE', 'BASELINE', 'CHANGE_ORDER_APPLIED', 'INTERNAL_METADATA');

-- CreateEnum
CREATE TYPE "ChangeOrderLineAction" AS ENUM ('ADD', 'REVISE', 'REMOVE');

-- CreateEnum
CREATE TYPE "ProcurementMethod" AS ENUM ('UNCLASSIFIED', 'PURCHASE_ORDER', 'WORK_ORDER', 'INTERNAL', 'NONE');

-- CreateEnum
CREATE TYPE "BudgetCostType" AS ENUM ('UNCLASSIFIED', 'MATERIAL', 'EQUIPMENT', 'RENTAL', 'SUBCONTRACT', 'INTERNAL_LABOR', 'OTHER');

-- CreateEnum
CREATE TYPE "PurchaseOrderLifecycleStatus" AS ENUM ('DRAFT', 'APPROVED', 'ISSUED', 'PARTIALLY_RECEIVED', 'RECEIVED', 'CLOSED', 'CANCELED', 'SUPERSEDED');

-- AlterTable
ALTER TABLE "Budget"
ADD COLUMN "lifecycleStatus" "BudgetLifecycleStatus" NOT NULL DEFAULT 'DRAFT',
ADD COLUMN "baselineVersionId" TEXT;

-- AlterTable
ALTER TABLE "BudgetVersion"
ADD COLUMN "kind" "BudgetVersionKind" NOT NULL DEFAULT 'SAVE',
ADD COLUMN "sourceDocumentId" TEXT,
ADD COLUMN "note" TEXT;

-- AlterTable
ALTER TABLE "BudgetDivision"
ADD COLUMN "archivedAt" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "BudgetLineItem"
ADD COLUMN "sku" TEXT,
ADD COLUMN "costType" "BudgetCostType" NOT NULL DEFAULT 'UNCLASSIFIED',
ADD COLUMN "procurementMethod" "ProcurementMethod" NOT NULL DEFAULT 'UNCLASSIFIED',
ADD COLUMN "preferredVendorId" TEXT,
ADD COLUMN "archivedAt" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "Document"
ADD COLUMN "revisionOfDocumentId" TEXT,
ADD COLUMN "creationIdempotencyKey" TEXT;

-- CreateTable
CREATE TABLE "ChangeOrder" (
    "id" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,
    "budgetId" TEXT,
    "sourceBudgetVersionId" TEXT,
    "appliedBudgetVersionId" TEXT,
    "reason" TEXT,
    "description" TEXT,
    "scheduleImpact" TEXT,
    "customTextValuesJson" JSONB,
    "appliedAt" TIMESTAMP(3),
    "legacyImportedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ChangeOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChangeOrderLine" (
    "id" TEXT NOT NULL,
    "changeOrderId" TEXT NOT NULL,
    "action" "ChangeOrderLineAction" NOT NULL,
    "sourceBudgetDivisionId" TEXT,
    "sourceBudgetLineItemId" TEXT,
    "appliedBudgetDivisionId" TEXT,
    "appliedBudgetLineItemId" TEXT,
    "originalDivisionName" TEXT,
    "divisionName" TEXT NOT NULL,
    "originalItemName" TEXT,
    "itemName" TEXT NOT NULL,
    "description" TEXT,
    "sku" TEXT,
    "originalUnit" TEXT,
    "unit" TEXT NOT NULL,
    "originalQuantity" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "proposedQuantity" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "originalUnitCost" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "proposedUnitCost" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "originalMarkupPercent" DECIMAL(8,4) NOT NULL DEFAULT 0,
    "proposedMarkupPercent" DECIMAL(8,4) NOT NULL DEFAULT 0,
    "originalAddTax" BOOLEAN NOT NULL DEFAULT false,
    "proposedAddTax" BOOLEAN NOT NULL DEFAULT false,
    "originalTaxPercent" DECIMAL(8,4) NOT NULL DEFAULT 0,
    "proposedTaxPercent" DECIMAL(8,4) NOT NULL DEFAULT 0,
    "costDelta" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "customerPriceDelta" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ChangeOrderLine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PurchaseOrder" (
    "id" TEXT NOT NULL,
    "documentId" TEXT NOT NULL,
    "budgetId" TEXT,
    "vendorId" TEXT,
    "lifecycleStatus" "PurchaseOrderLifecycleStatus" NOT NULL DEFAULT 'DRAFT',
    "shipToAddressJson" JSONB,
    "requestedDeliveryDate" TIMESTAMP(3),
    "instructions" TEXT,
    "customTextValuesJson" JSONB,
    "allowOverOrder" BOOLEAN NOT NULL DEFAULT false,
    "approvedAt" TIMESTAMP(3),
    "issuedAt" TIMESTAMP(3),
    "closedAt" TIMESTAMP(3),
    "canceledAt" TIMESTAMP(3),
    "legacyImportedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PurchaseOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PurchaseOrderLine" (
    "id" TEXT NOT NULL,
    "purchaseOrderId" TEXT NOT NULL,
    "sourceBudgetDivisionId" TEXT,
    "sourceBudgetLineItemId" TEXT,
    "divisionName" TEXT NOT NULL,
    "itemName" TEXT NOT NULL,
    "description" TEXT,
    "sku" TEXT,
    "orderedQuantity" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "receivedQuantity" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "unit" TEXT NOT NULL,
    "vendorUnitCost" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "taxRate" DECIMAL(8,4) NOT NULL DEFAULT 0,
    "lineSubtotal" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "lineTax" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "lineTotal" DECIMAL(18,2) NOT NULL DEFAULT 0,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PurchaseOrderLine_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Budget_baselineVersionId_key" ON "Budget"("baselineVersionId");

-- CreateIndex
CREATE UNIQUE INDEX "BudgetVersion_sourceDocumentId_key" ON "BudgetVersion"("sourceDocumentId");

-- CreateIndex
CREATE INDEX "BudgetDivision_budgetId_archivedAt_idx" ON "BudgetDivision"("budgetId", "archivedAt");

-- CreateIndex
CREATE INDEX "BudgetLineItem_companyId_archivedAt_idx" ON "BudgetLineItem"("companyId", "archivedAt");

-- CreateIndex
CREATE INDEX "BudgetLineItem_preferredVendorId_idx" ON "BudgetLineItem"("preferredVendorId");

-- CreateIndex
CREATE INDEX "Document_revisionOfDocumentId_idx" ON "Document"("revisionOfDocumentId");

-- CreateIndex
CREATE UNIQUE INDEX "Document_companyId_creationIdempotencyKey_key" ON "Document"("companyId", "creationIdempotencyKey");

-- CreateIndex
CREATE UNIQUE INDEX "ChangeOrder_documentId_key" ON "ChangeOrder"("documentId");

-- CreateIndex
CREATE UNIQUE INDEX "ChangeOrder_appliedBudgetVersionId_key" ON "ChangeOrder"("appliedBudgetVersionId");

-- CreateIndex
CREATE INDEX "ChangeOrder_budgetId_idx" ON "ChangeOrder"("budgetId");

-- CreateIndex
CREATE INDEX "ChangeOrder_sourceBudgetVersionId_idx" ON "ChangeOrder"("sourceBudgetVersionId");

-- CreateIndex
CREATE INDEX "ChangeOrder_appliedAt_idx" ON "ChangeOrder"("appliedAt");

-- CreateIndex
CREATE INDEX "ChangeOrderLine_changeOrderId_sortOrder_idx" ON "ChangeOrderLine"("changeOrderId", "sortOrder");

-- CreateIndex
CREATE INDEX "ChangeOrderLine_sourceBudgetLineItemId_idx" ON "ChangeOrderLine"("sourceBudgetLineItemId");

-- CreateIndex
CREATE INDEX "ChangeOrderLine_appliedBudgetLineItemId_idx" ON "ChangeOrderLine"("appliedBudgetLineItemId");

-- CreateIndex
CREATE UNIQUE INDEX "PurchaseOrder_documentId_key" ON "PurchaseOrder"("documentId");

-- CreateIndex
CREATE INDEX "PurchaseOrder_budgetId_idx" ON "PurchaseOrder"("budgetId");

-- CreateIndex
CREATE INDEX "PurchaseOrder_vendorId_lifecycleStatus_idx" ON "PurchaseOrder"("vendorId", "lifecycleStatus");

-- CreateIndex
CREATE INDEX "PurchaseOrderLine_purchaseOrderId_sortOrder_idx" ON "PurchaseOrderLine"("purchaseOrderId", "sortOrder");

-- CreateIndex
CREATE INDEX "PurchaseOrderLine_sourceBudgetLineItemId_idx" ON "PurchaseOrderLine"("sourceBudgetLineItemId");

-- AddForeignKey
ALTER TABLE "Budget" ADD CONSTRAINT "Budget_baselineVersionId_fkey" FOREIGN KEY ("baselineVersionId") REFERENCES "BudgetVersion"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BudgetVersion" ADD CONSTRAINT "BudgetVersion_sourceDocumentId_fkey" FOREIGN KEY ("sourceDocumentId") REFERENCES "Document"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BudgetLineItem" ADD CONSTRAINT "BudgetLineItem_preferredVendorId_fkey" FOREIGN KEY ("preferredVendorId") REFERENCES "Vendor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Document" ADD CONSTRAINT "Document_revisionOfDocumentId_fkey" FOREIGN KEY ("revisionOfDocumentId") REFERENCES "Document"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeOrder" ADD CONSTRAINT "ChangeOrder_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeOrder" ADD CONSTRAINT "ChangeOrder_budgetId_fkey" FOREIGN KEY ("budgetId") REFERENCES "Budget"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeOrder" ADD CONSTRAINT "ChangeOrder_sourceBudgetVersionId_fkey" FOREIGN KEY ("sourceBudgetVersionId") REFERENCES "BudgetVersion"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeOrder" ADD CONSTRAINT "ChangeOrder_appliedBudgetVersionId_fkey" FOREIGN KEY ("appliedBudgetVersionId") REFERENCES "BudgetVersion"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeOrderLine" ADD CONSTRAINT "ChangeOrderLine_changeOrderId_fkey" FOREIGN KEY ("changeOrderId") REFERENCES "ChangeOrder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeOrderLine" ADD CONSTRAINT "ChangeOrderLine_sourceBudgetDivisionId_fkey" FOREIGN KEY ("sourceBudgetDivisionId") REFERENCES "BudgetDivision"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeOrderLine" ADD CONSTRAINT "ChangeOrderLine_sourceBudgetLineItemId_fkey" FOREIGN KEY ("sourceBudgetLineItemId") REFERENCES "BudgetLineItem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeOrderLine" ADD CONSTRAINT "ChangeOrderLine_appliedBudgetDivisionId_fkey" FOREIGN KEY ("appliedBudgetDivisionId") REFERENCES "BudgetDivision"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChangeOrderLine" ADD CONSTRAINT "ChangeOrderLine_appliedBudgetLineItemId_fkey" FOREIGN KEY ("appliedBudgetLineItemId") REFERENCES "BudgetLineItem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_documentId_fkey" FOREIGN KEY ("documentId") REFERENCES "Document"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_budgetId_fkey" FOREIGN KEY ("budgetId") REFERENCES "Budget"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "Vendor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrderLine" ADD CONSTRAINT "PurchaseOrderLine_purchaseOrderId_fkey" FOREIGN KEY ("purchaseOrderId") REFERENCES "PurchaseOrder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrderLine" ADD CONSTRAINT "PurchaseOrderLine_sourceBudgetDivisionId_fkey" FOREIGN KEY ("sourceBudgetDivisionId") REFERENCES "BudgetDivision"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PurchaseOrderLine" ADD CONSTRAINT "PurchaseOrderLine_sourceBudgetLineItemId_fkey" FOREIGN KEY ("sourceBudgetLineItemId") REFERENCES "BudgetLineItem"("id") ON DELETE SET NULL ON UPDATE CASCADE;
