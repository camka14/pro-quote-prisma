-- CreateTable
CREATE TABLE "BudgetVersion" (
    "id" TEXT NOT NULL,
    "budgetId" TEXT NOT NULL,
    "versionNumber" INTEGER NOT NULL,
    "createdById" TEXT NOT NULL,
    "totalAmount" DECIMAL(18,2) NOT NULL,
    "breakdownJson" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BudgetVersion_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "BudgetVersion_budgetId_idx" ON "BudgetVersion"("budgetId");

-- CreateIndex
CREATE INDEX "BudgetVersion_createdById_idx" ON "BudgetVersion"("createdById");

-- CreateIndex
CREATE UNIQUE INDEX "BudgetVersion_budgetId_versionNumber_key" ON "BudgetVersion"("budgetId", "versionNumber");

-- AddForeignKey
ALTER TABLE "BudgetVersion" ADD CONSTRAINT "BudgetVersion_budgetId_fkey" FOREIGN KEY ("budgetId") REFERENCES "Budget"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BudgetVersion" ADD CONSTRAINT "BudgetVersion_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
