-- CreateEnum
CREATE TYPE "OnboardingTourStatus" AS ENUM ('not_started', 'in_progress', 'completed', 'skipped');

-- AlterTable
ALTER TABLE "User"
ADD COLUMN "onboardingTourStatus" "OnboardingTourStatus" DEFAULT 'not_started',
ADD COLUMN "onboardingTourStep" INTEGER,
ADD COLUMN "onboardingTourStartedAt" TIMESTAMP(3),
ADD COLUMN "onboardingTourCompletedAt" TIMESTAMP(3),
ADD COLUMN "onboardingTrialPromptedAt" TIMESTAMP(3),
ADD COLUMN "onboardingTrialDeclinedAt" TIMESTAMP(3),
ADD COLUMN "onboardingDemoAccessUntil" TIMESTAMP(3);
