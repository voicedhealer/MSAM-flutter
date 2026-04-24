-- MSAM - Schema V2 (Option A)
-- Ce script cree les tables V2 sans toucher auth.users.

create extension if not exists "pgcrypto";

create table if not exists public.profiles_v2 (
  id uuid primary key references auth.users(id) on delete cascade,
  first_name text not null default '',
  email text not null default '',
  phone text,
  city text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.vehicles_v2 (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  plate text not null,
  make text,
  model text,
  year int,
  energy text check (energy in ('thermal', 'electric', 'hybrid')),
  vehicle_type text check (vehicle_type in ('car', 'motorcycle')),
  mileage_km int,
  is_primary boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.maintenances_v2 (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  vehicle_id uuid not null references public.vehicles_v2(id) on delete cascade,
  maintenance_type text not null,
  maintenance_date date not null,
  mileage_km int,
  cost_eur numeric(10,2),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.reminders_v2 (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  vehicle_id uuid not null references public.vehicles_v2(id) on delete cascade,
  reminder_type text not null,
  due_date date,
  due_mileage_km int,
  is_done boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_vehicles_v2_user_id on public.vehicles_v2(user_id);
create index if not exists idx_maintenances_v2_user_id on public.maintenances_v2(user_id);
create index if not exists idx_maintenances_v2_vehicle_id on public.maintenances_v2(vehicle_id);
create index if not exists idx_reminders_v2_user_id on public.reminders_v2(user_id);
create index if not exists idx_reminders_v2_vehicle_id on public.reminders_v2(vehicle_id);

alter table public.profiles_v2 enable row level security;
alter table public.vehicles_v2 enable row level security;
alter table public.maintenances_v2 enable row level security;
alter table public.reminders_v2 enable row level security;

drop policy if exists "profiles_v2_select_own" on public.profiles_v2;
create policy "profiles_v2_select_own"
on public.profiles_v2 for select
using (auth.uid() = id);

drop policy if exists "profiles_v2_insert_own" on public.profiles_v2;
create policy "profiles_v2_insert_own"
on public.profiles_v2 for insert
with check (auth.uid() = id);

drop policy if exists "profiles_v2_update_own" on public.profiles_v2;
create policy "profiles_v2_update_own"
on public.profiles_v2 for update
using (auth.uid() = id);

drop policy if exists "vehicles_v2_all_own" on public.vehicles_v2;
create policy "vehicles_v2_all_own"
on public.vehicles_v2 for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "maintenances_v2_all_own" on public.maintenances_v2;
create policy "maintenances_v2_all_own"
on public.maintenances_v2 for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "reminders_v2_all_own" on public.reminders_v2;
create policy "reminders_v2_all_own"
on public.reminders_v2 for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
