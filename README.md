# MSAM-flutter

Base de travail pour l'application mobile `Mon-Suivi-Auto-Moto` (MSAM).

## Documents cles

- `CHARTE_MSAM.md` : reference produit + charte graphique + regles.
- `docs/ARCHITECTURE.md` : architecture Flutter recommandee.
- `docs/EXECUTION_ORDER.md` : ordre de mise en oeuvre.
- `docs/SPRINT_BACKLOG.md` : backlog sprint priorise.

## Base de donnees

- `supabase/migrations/0001_v2_schema.sql` : schema V2 + RLS.
- `supabase/migrations/0002_v1_to_v2_migration.sql` : migration option A.

## Squelette Flutter

- `lib/main.dart`
- `lib/app/app.dart`
- `lib/core/*`
- `lib/shared/*`
- `lib/features/*`