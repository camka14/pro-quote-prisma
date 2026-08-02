ALTER TABLE "User"
ADD COLUMN "interfaceLanguage" TEXT NOT NULL DEFAULT 'en',
ADD COLUMN "assistantReplyLanguage" TEXT NOT NULL DEFAULT 'auto',
ADD COLUMN "workProductLanguage" TEXT NOT NULL DEFAULT 'en',
ADD COLUMN "languagePreferencesSetAt" TIMESTAMP(3);
