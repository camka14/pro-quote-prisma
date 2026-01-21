# Pro Quote Prisma Schema

This folder contains the shared Prisma schema and migrations for Pro Quote.

## Contents

- `schema.prisma`
- `migrations/`

## Usage

- For reuse in another repo, add this folder as a git submodule or subtree at `prisma/` so the schema path is `prisma/schema.prisma`.
- If your project keeps the schema elsewhere, point Prisma CLI to the schema path (for example, via `prisma.config.ts` or `package.json` `prisma.schema`).
- The generator output is currently set to `../generated/prisma` to keep the Next.js app imports stable. Update the generator `output` path if you mount this schema in a different project layout.
