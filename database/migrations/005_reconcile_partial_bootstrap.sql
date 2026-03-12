-- Reconcile partial bootstrap state after iterative fixes during initial schema setup.
-- Safe to run on environments where part of 004_schema_from_docs.sql was applied.

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'flows'
      AND column_name = 'user_id'
      AND is_nullable = 'NO'
  ) THEN
    ALTER TABLE public.flows
      ALTER COLUMN user_id DROP NOT NULL;
  END IF;
END $$;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'broadcasts'
      AND column_name = 'target_segment_id'
  )
  AND EXISTS (
    SELECT 1
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_name = 'segments'
  )
  AND NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE conname = 'broadcasts_target_segment_id_fkey'
  ) THEN
    ALTER TABLE public.broadcasts
      ADD CONSTRAINT broadcasts_target_segment_id_fkey
      FOREIGN KEY (target_segment_id)
      REFERENCES public.segments(id)
      ON DELETE SET NULL;
  END IF;
END $$;

-- Note:
-- The bootstrap no longer attempts token encryption backfill.
-- Keep encryption logic in server-side application code or Edge Functions.
