-- Remove division-level labor fields now that labor is represented as line items.
-- At this point in the migration history the table is still named EstimateDivision,
-- but keep BudgetDivision for safety if the rename already happened in a shadow DB.
ALTER TABLE IF EXISTS "EstimateDivision" DROP COLUMN IF EXISTS "laborHours";
ALTER TABLE IF EXISTS "EstimateDivision" DROP COLUMN IF EXISTS "laborRate";
ALTER TABLE IF EXISTS "BudgetDivision" DROP COLUMN IF EXISTS "laborHours";
ALTER TABLE IF EXISTS "BudgetDivision" DROP COLUMN IF EXISTS "laborRate";
