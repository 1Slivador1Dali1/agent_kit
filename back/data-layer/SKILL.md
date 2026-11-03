---
name: data-layer
description: Design database schemas, write safe migrations, queries, indexes and transactions. Use whenever touching tables, models, ORM entities, migrations, SQL, repositories, or queries, or when the user mentions "база данных", "миграция", "схема", "индекс", "запрос", "N+1", "транзакция", "postgres", "mysql", "mongodb".
---

# Data Layer

Inspect the existing ORM/migration tool and naming conventions first, and follow them. Never edit an already-applied migration; add a new one.

## Schema design

- Model the domain first: entities, relationships, invariants. Enforce invariants in the database (NOT NULL, UNIQUE, CHECK, foreign keys), not only in app code.
- Primary keys: stable surrogate id (bigint identity or UUIDv7/ULID). Do not expose sequential ids if enumeration is a risk.
- Types: `timestamptz` / UTC for time, exact decimal or integer minor units for money (never float), enums or lookup tables for closed sets, JSON columns only for truly schemaless data.
- Naming: consistent, singular or plural per project convention; FK columns `<entity>_id`; `created_at`, `updated_at` everywhere; soft delete (`deleted_at`) only when the product needs recovery or audit.
- Normalize by default; denormalize deliberately with a reason (read performance) and a way to keep it correct.

## Indexes

- Index every foreign key and every column used in frequent WHERE / JOIN / ORDER BY.
- Composite index order: equality columns first, then range, then sort.
- Partial and covering indexes where they fit. Do not over-index write-heavy tables.
- Check query plans (`EXPLAIN ANALYZE`) for anything on a hot path or large table.

## Queries

- Parameterized queries or ORM only; never string-concatenate user input.
- Avoid N+1: use joins, `IN` batches, eager loading, or dataloaders. Select only needed columns on large rows.
- Paginate every list query; keyset pagination for large tables.
- Keep transactions short; no network calls inside a transaction. Define isolation needs explicitly; use `SELECT ... FOR UPDATE` or optimistic versioning for contested rows.
- Bulk operations in batches. Use upserts (`ON CONFLICT`) for idempotent writes.

## Migrations (zero-downtime mindset)

1. Additive first: add nullable column / new table / new index (`CONCURRENTLY` where supported).
2. Backfill in batches, outside the main migration transaction for big tables.
3. Deploy code that uses the new structure (dual-write if needed).
4. Only then add NOT NULL / constraints and drop old columns in a later migration.
- Each migration is reversible or has a documented rollback plan. Never rename or drop a column in the same release that stops using it.
- Warn explicitly about locks, table rewrites and long backfills.

## Output

Schema or migration files, the indexes with the query they serve, notes on locking/backfill risks, and any query that needs a plan check.
