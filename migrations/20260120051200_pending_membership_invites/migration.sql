-- CreateEnum
CREATE TYPE "MembershipStatus" AS ENUM ('pending', 'accepted', 'rejected');

-- AlterTable
ALTER TABLE "Membership" ADD COLUMN "email" TEXT;
ALTER TABLE "Membership" ADD COLUMN "status" "MembershipStatus" NOT NULL DEFAULT 'accepted';
ALTER TABLE "Membership" ALTER COLUMN "userId" DROP NOT NULL;

-- Backfill existing membership emails from users
UPDATE "Membership"
SET "email" = LOWER("User"."email")
FROM "User"
WHERE "Membership"."userId" = "User"."id"
  AND "User"."email" IS NOT NULL;

-- Add unique constraint for company/email
CREATE UNIQUE INDEX "Membership_companyId_email_key" ON "Membership"("companyId", "email");

-- Migrate pending invites into memberships
INSERT INTO "Membership" ("id", "companyId", "teamId", "email", "status", "createdAt", "updatedAt")
SELECT
  md5(random()::text || clock_timestamp()::text || c."id" || COALESCE(elem::text, '')),
  c."id",
  CASE
    WHEN jsonb_typeof(elem) = 'object' THEN NULLIF(elem->>'teamId', '')
    ELSE NULL
  END,
  CASE
    WHEN jsonb_typeof(elem) = 'string' THEN LOWER(TRIM(BOTH '"' FROM elem::text))
    WHEN jsonb_typeof(elem) = 'object' THEN LOWER(elem->>'email')
    ELSE NULL
  END,
  'pending'::"MembershipStatus",
  NOW(),
  NOW()
FROM "Company" c
CROSS JOIN LATERAL jsonb_array_elements(c."inviteEmails") elem
WHERE c."inviteEmails" IS NOT NULL
  AND (
    (jsonb_typeof(elem) = 'string' AND LENGTH(TRIM(BOTH '"' FROM elem::text)) > 0)
    OR (jsonb_typeof(elem) = 'object' AND elem ? 'email' AND LENGTH(TRIM(elem->>'email')) > 0)
  )
ON CONFLICT ("companyId", "email") DO NOTHING;

-- DropColumn
ALTER TABLE "Company" DROP COLUMN "inviteEmails";
