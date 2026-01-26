/*
  Warnings:

  - Made the column `street1` on table `Project` required. This step will fail if there are existing NULL values in that column.
  - Made the column `city` on table `Project` required. This step will fail if there are existing NULL values in that column.
  - Made the column `state` on table `Project` required. This step will fail if there are existing NULL values in that column.
  - Made the column `zipCode` on table `Project` required. This step will fail if there are existing NULL values in that column.
  - Made the column `country` on table `Project` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "Project" ADD COLUMN     "name" TEXT,
ALTER COLUMN "street1" SET NOT NULL,
ALTER COLUMN "city" SET NOT NULL,
ALTER COLUMN "state" SET NOT NULL,
ALTER COLUMN "zipCode" SET NOT NULL,
ALTER COLUMN "country" SET NOT NULL;
