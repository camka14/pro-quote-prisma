-- Drop budgetName now that budgets are tied to projects
ALTER TABLE "Budget" DROP COLUMN "budgetName";
