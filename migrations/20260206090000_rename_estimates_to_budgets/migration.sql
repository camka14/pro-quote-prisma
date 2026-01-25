-- Rename estimate tables to budget tables.
ALTER TABLE "Estimate" RENAME TO "Budget";
ALTER TABLE "EstimateDivision" RENAME TO "BudgetDivision";
ALTER TABLE "EstimateLineItem" RENAME TO "BudgetLineItem";
ALTER TABLE "EstimateDivisionLineItem" RENAME TO "BudgetDivisionLineItem";

-- Rename columns to budget naming.
ALTER TABLE "Budget" RENAME COLUMN "estimateName" TO "budgetName";
ALTER TABLE "BudgetDivision" RENAME COLUMN "estimateId" TO "budgetId";
ALTER TABLE "BudgetDivisionLineItem" RENAME COLUMN "estimateDivisionId" TO "budgetDivisionId";
ALTER TABLE "Quote" RENAME COLUMN "estimateId" TO "budgetId";
ALTER TABLE "SharedLink" RENAME COLUMN "estimateIds" TO "budgetIds";

-- Update project statuses to new vocabulary.
UPDATE "Project" SET "status" = 'BUDGET_SENT' WHERE "status" = 'ESTIMATE_SENT';

-- Update role permissions JSON keys if present.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'Role'
      AND column_name = 'permissions'
  ) THEN
    UPDATE "Role"
    SET "permissions" = jsonb_set(
      "permissions" - 'estimates',
      '{budgets}',
      "permissions"->'estimates',
      true
    )
    WHERE "permissions" ? 'estimates';
  END IF;
END $$;
