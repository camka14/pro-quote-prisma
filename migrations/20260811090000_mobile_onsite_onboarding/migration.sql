-- Add stable flow and step identifiers while retaining the legacy numeric step.
ALTER TABLE "User"
ADD COLUMN "onboardingTourFlow" TEXT,
ADD COLUMN "onboardingTourStepId" TEXT;

-- Existing in-progress users were using the desktop tour. Preserve that meaning.
UPDATE "User"
SET "onboardingTourFlow" = 'desktop_v1'
WHERE "onboardingTourStatus" = 'in_progress'
  AND "onboardingTourFlow" IS NULL;
