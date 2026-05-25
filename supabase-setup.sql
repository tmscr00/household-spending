-- ============================================================
--  HOUSEHOLD SPENDING — Supabase setup
--  ------------------------------------------------------------
--  Run this ONCE in your Supabase project:
--  Supabase dashboard -> SQL Editor -> New query -> paste all
--  of this -> Run. See README.md Step 3.
-- ============================================================

-- 1. The expenses table -------------------------------------
create table if not exists expenses (
  id          text primary key,
  household   text not null default 'samet-ellen',
  amount      numeric not null,
  category    text not null check (category in ('Groceries','Misc')),
  note        text,
  added_by    text not null check (added_by in ('Samet','Ellen')),
  spent_on    date not null default current_date,
  receipt_path text,
  created_at  timestamptz not null default now()
);

-- 2. A tiny settings table for the weekly budget ------------
create table if not exists settings (
  household      text primary key default 'samet-ellen',
  weekly_budget  numeric not null default 100
);

insert into settings (household, weekly_budget)
values ('samet-ellen', 100)
on conflict (household) do nothing;

-- 3. Turn on row-level security -----------------------------
alter table expenses enable row level security;
alter table settings enable row level security;

-- 4. Access policies ----------------------------------------
--    This is a private two-person app with no login, so we
--    allow full access using the public anon key. The app is
--    only as discoverable as its secret URL. If you later add
--    Supabase Auth, tighten these to check auth.uid().
drop policy if exists "open expenses" on expenses;
create policy "open expenses" on expenses
  for all using (true) with check (true);

drop policy if exists "open settings" on settings;
create policy "open settings" on settings
  for all using (true) with check (true);

-- 5. Realtime so both phones update live --------------------
alter publication supabase_realtime add table expenses;
alter publication supabase_realtime add table settings;

-- 6. A private bucket for receipt photos --------------------
insert into storage.buckets (id, name, public)
values ('receipts', 'receipts', true)
on conflict (id) do nothing;

drop policy if exists "open receipts" on storage.objects;
create policy "open receipts" on storage.objects
  for all using (bucket_id = 'receipts') with check (bucket_id = 'receipts');

-- Done. Go back to the README, Step 4.
