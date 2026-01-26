-- Remove division-level labor fields now that labor is represented as line items
ALTER TABLE "BudgetDivision" DROP COLUMN "laborHours";
ALTER TABLE "BudgetDivision" DROP COLUMN "laborRate";
