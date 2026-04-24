# Ordre d'execution recommande

## Etape 1 - Base technique

1. Lire `CHARTE_MSAM.md`
2. Mettre en place l'architecture `lib/`
3. Configurer Supabase cote Flutter

## Etape 2 - Base de donnees V2

1. Executer `supabase/migrations/0001_v2_schema.sql`
2. Verifier RLS/policies
3. Tester creation lecture ecriture avec un compte test

## Etape 3 - Migration Option A

1. Auditer les tables V1 existantes
2. Adapter si besoin `0002_v1_to_v2_migration.sql`
3. Executer en preprod
4. Verifier les donnees migrees

## Etape 4 - Produit

1. Onboarding minimal
2. Dashboard
3. Ajout entretien rapide
4. Rappels

## Etape 5 - Stabilisation

1. QA fonctionnelle complete
2. Accessibilite et performances
3. Beta distribution
