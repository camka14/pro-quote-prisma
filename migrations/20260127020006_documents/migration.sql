/*
  Warnings:

  - A unique constraint covering the columns `[currentVersionId]` on the table `Document` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
DO $$
BEGIN
  IF to_regclass('public."Document"') IS NOT NULL THEN
    CREATE UNIQUE INDEX IF NOT EXISTS "Document_currentVersionId_key" ON "Document"("currentVersionId");
  END IF;
END $$;
