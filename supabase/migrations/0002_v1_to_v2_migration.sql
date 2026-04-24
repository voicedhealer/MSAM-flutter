-- MSAM - Migration V1 -> V2 (Option A)
-- IMPORTANT:
-- 1) Verifier les noms de tables/colonnes V1 avant execution.
-- 2) Executer d'abord en preproduction.

begin;

-- 1) Profiles: auth.users -> profiles_v2 si non existant
insert into public.profiles_v2 (id, first_name, email)
select
  au.id,
  coalesce(split_part(au.email, '@', 1), ''),
  coalesce(au.email, '')
from auth.users au
left join public.profiles_v2 p on p.id = au.id
where p.id is null;

-- 2) Exemple de migration vehicules V1 -> V2
-- Adaptez les noms selon votre schema V1 reel:
-- public.vehicles(id, user_id, plate, make, model, year, energy, vehicle_type, mileage_km)
do $$
begin
  if exists (
    select 1
    from information_schema.tables
    where table_schema = 'public'
      and table_name = 'vehicles'
  ) then
    insert into public.vehicles_v2 (
      user_id, plate, make, model, year, energy, vehicle_type, mileage_km, is_primary
    )
    select
      v.user_id,
      v.plate,
      v.make,
      v.model,
      v.year,
      case
        when v.energy in ('thermal', 'electric', 'hybrid') then v.energy
        else 'thermal'
      end,
      case
        when v.vehicle_type in ('car', 'motorcycle') then v.vehicle_type
        else 'car'
      end,
      v.mileage_km,
      true
    from public.vehicles v
    where not exists (
      select 1
      from public.vehicles_v2 v2
      where v2.user_id = v.user_id
        and v2.plate = v.plate
    );
  end if;
end $$;

-- 3) Exemple de migration entretiens V1 -> V2
-- Adaptez les noms selon votre schema V1 reel:
-- public.maintenances(id, user_id, vehicle_id, type, date, mileage_km, cost_eur, notes)
do $$
begin
  if exists (
    select 1
    from information_schema.tables
    where table_schema = 'public'
      and table_name = 'maintenances'
  ) then
    insert into public.maintenances_v2 (
      user_id, vehicle_id, maintenance_type, maintenance_date, mileage_km, cost_eur, notes
    )
    select
      m.user_id,
      map_v2.id as vehicle_id,
      coalesce(m.type, 'other'),
      coalesce(m.date::date, now()::date),
      m.mileage_km,
      m.cost_eur,
      m.notes
    from public.maintenances m
    join public.vehicles old_v on old_v.id = m.vehicle_id
    join public.vehicles_v2 map_v2
      on map_v2.user_id = old_v.user_id
     and map_v2.plate = old_v.plate
    where not exists (
      select 1
      from public.maintenances_v2 m2
      where m2.user_id = m.user_id
        and m2.vehicle_id = map_v2.id
        and m2.maintenance_date = coalesce(m.date::date, now()::date)
        and m2.maintenance_type = coalesce(m.type, 'other')
    );
  end if;
end $$;

commit;
