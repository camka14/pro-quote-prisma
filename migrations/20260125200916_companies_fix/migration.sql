-- AlterTable
ALTER TABLE "Budget" RENAME CONSTRAINT "Estimate_pkey" TO "Budget_pkey";

-- AlterTable
ALTER TABLE "BudgetDivision" RENAME CONSTRAINT "EstimateDivision_pkey" TO "BudgetDivision_pkey";

-- AlterTable
ALTER TABLE "BudgetDivisionLineItem" RENAME CONSTRAINT "EstimateDivisionLineItem_pkey" TO "BudgetDivisionLineItem_pkey";

-- AlterTable
ALTER TABLE "BudgetLineItem" RENAME CONSTRAINT "EstimateLineItem_pkey" TO "BudgetLineItem_pkey";

-- RenameForeignKey
ALTER TABLE "Budget" RENAME CONSTRAINT "Estimate_companyId_fkey" TO "Budget_companyId_fkey";

-- RenameForeignKey
ALTER TABLE "Budget" RENAME CONSTRAINT "Estimate_projectId_fkey" TO "Budget_projectId_fkey";

-- RenameForeignKey
ALTER TABLE "Budget" RENAME CONSTRAINT "Estimate_userId_fkey" TO "Budget_userId_fkey";

-- RenameForeignKey
ALTER TABLE "BudgetDivision" RENAME CONSTRAINT "EstimateDivision_companyId_fkey" TO "BudgetDivision_companyId_fkey";

-- RenameForeignKey
ALTER TABLE "BudgetDivision" RENAME CONSTRAINT "EstimateDivision_estimateId_fkey" TO "BudgetDivision_budgetId_fkey";

-- RenameForeignKey
ALTER TABLE "BudgetDivisionLineItem" RENAME CONSTRAINT "EstimateDivisionLineItem_estimateDivisionId_fkey" TO "BudgetDivisionLineItem_budgetDivisionId_fkey";

-- RenameForeignKey
ALTER TABLE "BudgetDivisionLineItem" RENAME CONSTRAINT "EstimateDivisionLineItem_lineItemId_fkey" TO "BudgetDivisionLineItem_lineItemId_fkey";

-- RenameForeignKey
ALTER TABLE "BudgetLineItem" RENAME CONSTRAINT "EstimateLineItem_companyId_fkey" TO "BudgetLineItem_companyId_fkey";

-- RenameForeignKey
ALTER TABLE "Quote" RENAME CONSTRAINT "Quote_estimateId_fkey" TO "Quote_budgetId_fkey";

-- RenameIndex
ALTER INDEX "EstimateDivisionLineItem_estimateDivisionId_lineItemId_key" RENAME TO "BudgetDivisionLineItem_budgetDivisionId_lineItemId_key";
