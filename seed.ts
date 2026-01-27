import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../generated/prisma/client.js";
import { config as loadEnv } from "dotenv";
import { randomBytes, scrypt as _scrypt } from "crypto";
import { promisify } from "util";
import { Pool, type PoolConfig } from "pg";
import { seedDefaultDocumentTemplates } from "../lib/documentTemplates.js";

// Prefer local env settings when present; fall back to .env defaults.
loadEnv({ path: ".env.local", override: true });
loadEnv();

const scrypt = promisify(_scrypt);

const ADMIN_TEAM_NAME = process.env.ADMIN_TEAM_NAME || "Admin";
const SYSTEM_USER_EMAIL = "system@local";

const FULL_ROLE_PERMISSIONS = {
  company: "edit",
  customers: "edit",
  projects: "edit",
  budgets: "edit",
  quotes: "edit",
};

const DEFAULT_CUSTOMER_ROLE_NAME = "Customer";
const DEFAULT_CUSTOMER_ROLE_PERMISSIONS = {
  company: "none",
  customers: "none",
  projects: "none",
  budgets: "none",
  quotes: "none",
  customerPortal: { canViewPrices: false },
};

const isTruthy = (value?: string): boolean => {
  if (!value) return false;
  return ["1", "true", "yes", "on", "require"].includes(value.toLowerCase());
};

const isDisabled = (value?: string): boolean => {
  if (!value) return false;
  return ["0", "false", "no", "off", "disable", "disabled"].includes(value.toLowerCase());
};

const parseOptionalInt = (value: string | undefined, label: string): number | undefined => {
  if (!value) return undefined;
  const parsed = Number.parseInt(value, 10);
  if (!Number.isFinite(parsed) || parsed < 0) {
    throw new Error(`${label} must be a non-negative integer.`);
  }
  return parsed;
};

const getSslConfig = (): PoolConfig["ssl"] => {
  if (isDisabled(process.env.DB_SSL) || isDisabled(process.env.PGSSLMODE)) {
    return undefined;
  }

  const allowInvalid =
    process.env.DB_SSL_ALLOW_INVALID === "true" || process.env.DATABASE_SSL_ALLOW_INVALID === "true";
  if (allowInvalid) {
    return { rejectUnauthorized: false };
  }

  const caBase64 =
    process.env.DB_CA_CERT_BASE64 ||
    process.env.DATABASE_CA_CERT_BASE64 ||
    process.env.PGSSLROOTCERT;
  const caRaw = process.env.DB_CA_CERT || process.env.DATABASE_CA_CERT;
  const ca = caBase64 ? Buffer.from(caBase64, "base64").toString("utf8") : caRaw;
  if (!ca) {
    if (isTruthy(process.env.DB_SSL) || isTruthy(process.env.PGSSLMODE)) {
      throw new Error("DB_SSL is enabled but no CA cert is set (DB_CA_CERT or DB_CA_CERT_BASE64).");
    }
    return undefined;
  }
  return { ca: ca.replace(/\\n/g, "\n"), rejectUnauthorized: true };
};

const getPoolConfig = (): PoolConfig => {
  const databaseUrl = process.env.DATABASE_URL;
  if (databaseUrl) {
    return {
      connectionString: databaseUrl,
      ssl: getSslConfig(),
    };
  }

  const host = process.env.DB_HOST || process.env.PGHOST;
  const portRaw = process.env.DB_PORT || process.env.PGPORT || "25060";
  const database = process.env.DB_NAME || process.env.PGDATABASE;
  const user = process.env.DB_USER || process.env.PGUSER;
  const password = process.env.DB_PASSWORD || process.env.PGPASSWORD;

  const missing: string[] = [];
  if (!host) missing.push("DB_HOST (or PGHOST)");
  if (!database) missing.push("DB_NAME (or PGDATABASE)");
  if (!user) missing.push("DB_USER (or PGUSER)");
  if (!password) missing.push("DB_PASSWORD (or PGPASSWORD)");
  if (missing.length) {
    throw new Error(`Missing database env vars: ${missing.join(", ")}`);
  }

  const port = Number.parseInt(portRaw, 10);
  const poolMax = parseOptionalInt(process.env.DB_POOL_MAX, "DB_POOL_MAX");
  const poolMin = parseOptionalInt(process.env.DB_POOL_MIN, "DB_POOL_MIN");
  if (poolMin !== undefined && poolMax !== undefined && poolMin > poolMax) {
    throw new Error("DB_POOL_MIN cannot be greater than DB_POOL_MAX.");
  }

  return {
    host,
    port: Number.isFinite(port) ? port : 25060,
    database,
    user,
    password,
    ssl: getSslConfig(),
    ...(poolMax !== undefined ? { max: poolMax } : {}),
    ...(poolMin !== undefined ? { min: poolMin } : {}),
  };
};

const prisma = new PrismaClient({
  adapter: new PrismaPg(new Pool(getPoolConfig())),
});

const hashPassword = async (plain: string): Promise<string> => {
  const salt = randomBytes(16);
  const derived = (await scrypt(plain, salt, 64)) as Buffer;
  return `${salt.toString("hex")}:${derived.toString("hex")}`;
};

const buildAdminRoleName = (companyName: string): string => {
  const base = companyName
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
  if (!base) return "company-admin";
  if (base.endsWith("admin")) return base;
  return `${base}-admin`;
};

const ensureCompanyAdminRole = async (companyId: string, companyName: string): Promise<void> => {
  const adminRoleName = buildAdminRoleName(companyName);
  const existing = await prisma.role.findFirst({
    where: { companyId, name: adminRoleName },
    select: { id: true },
  });
  if (existing) return;
  await prisma.role.create({
    data: {
      companyId,
      name: adminRoleName,
      permissions: FULL_ROLE_PERMISSIONS,
    },
  });
};

const ensureDefaultCustomerRole = async (companyId: string): Promise<void> => {
  const existing = await prisma.role.findFirst({
    where: { companyId, name: DEFAULT_CUSTOMER_ROLE_NAME },
    select: { id: true },
  });
  if (existing) return;
  await prisma.role.create({
    data: {
      companyId,
      name: DEFAULT_CUSTOMER_ROLE_NAME,
      permissions: DEFAULT_CUSTOMER_ROLE_PERMISSIONS,
    },
  });
};

const ensureSystemUser = async (): Promise<string> => {
  const existing = await prisma.user.findUnique({
    where: { email: SYSTEM_USER_EMAIL },
    select: { id: true },
  });
  if (existing) return existing.id;

  const passwordHash = await hashPassword(randomBytes(16).toString("hex"));
  const created = await prisma.user.create({
    data: {
      email: SYSTEM_USER_EMAIL,
      passwordHash,
      name: "System",
    },
    select: { id: true },
  });
  return created.id;
};

const ensureAdminCompany = async (): Promise<string> => {
  const existing = await prisma.company.findFirst({
    where: { isSystem: true },
    select: { id: true, name: true },
  });
  if (existing) {
    await ensureCompanyAdminRole(existing.id, existing.name);
    await ensureDefaultCustomerRole(existing.id);
    return existing.id;
  }

  const systemOwnerId = await ensureSystemUser();
  const company = await prisma.company.create({
    data: {
      name: ADMIN_TEAM_NAME,
      ownerId: systemOwnerId,
      isSystem: true,
    },
    select: { id: true },
  });
  await ensureCompanyAdminRole(company.id, ADMIN_TEAM_NAME);
  await ensureDefaultCustomerRole(company.id);
  return company.id;
};

const seedAdminUser = async (adminCompanyId: string) => {
  const email = process.env.ADMIN_SEED_EMAIL;
  const password = process.env.ADMIN_SEED_PASSWORD;
  const name = process.env.ADMIN_SEED_NAME || "Admin";

  if (!email || !password) {
    console.log(
      "Skipped admin user seed: set ADMIN_SEED_EMAIL and ADMIN_SEED_PASSWORD to create a default admin account.",
    );
    return;
  }

  const passwordHash = await hashPassword(password);

  const user = await prisma.user.upsert({
    where: { email },
    update: {},
    create: {
      email,
      name,
      passwordHash,
      defaultCompanyId: adminCompanyId,
    },
  });

  const adminCompany = await prisma.company.findUnique({
    where: { id: adminCompanyId },
    select: { id: true, name: true },
  });
  const adminRoleName = adminCompany ? buildAdminRoleName(adminCompany.name) : null;
  const adminRole = adminRoleName
    ? await prisma.role.findFirst({
        where: { companyId: adminCompanyId, name: adminRoleName },
        select: { id: true },
      })
    : null;
  const resolvedAdminRoleId = adminRole?.id
    ? adminRole.id
    : adminCompany
      ? (
          await prisma.role.create({
            data: {
              companyId: adminCompanyId,
              name: adminRoleName ?? "admin",
              permissions: FULL_ROLE_PERMISSIONS,
            },
            select: { id: true },
          })
        ).id
      : null;

  await prisma.membership.upsert({
    where: {
      userId_companyId: {
        userId: user.id,
        companyId: adminCompanyId,
      },
    },
    update: { roleId: resolvedAdminRoleId, email: user.email.toLowerCase(), status: "accepted" },
    create: {
      userId: user.id,
      companyId: adminCompanyId,
      roleId: resolvedAdminRoleId,
      email: user.email.toLowerCase(),
      status: "accepted",
    },
  });

  if (user.defaultCompanyId !== adminCompanyId) {
    await prisma.user.update({
      where: { id: user.id },
      data: { defaultCompanyId: adminCompanyId },
    });
  }

  console.log(`Seeded admin user ${email} in admin company ${adminCompanyId}`);
};

async function main() {
  const adminCompanyId = await ensureAdminCompany();
  console.log(`Ensured admin company exists: ${adminCompanyId}`);

  await seedAdminUser(adminCompanyId);

  const systemUserId = await ensureSystemUser();
  const templateSeed = await seedDefaultDocumentTemplates(prisma, adminCompanyId, systemUserId);
  if (templateSeed.created > 0) {
    console.log(`Seeded ${templateSeed.created} default document templates.`);
  }
}

main()
  .catch((error) => {
    console.error("Seeding failed:", error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
