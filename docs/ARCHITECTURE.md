# Architecture Flutter MSAM (V1)

Ce document definit la base technique pour l'application mobile `Mon-Suivi-Auto-Moto`.

## 1) Principes

- Architecture feature-first, lisible et evolutive.
- Separation claire: `presentation`, `application`, `domain`, `data`.
- UI simple, rapide, orientee actions utilisateur.
- Branchements backend uniquement sur le schema Supabase `V2`.

## 2) Arborescence recommandee

```text
lib/
  app/
    app.dart
  core/
    config/
      env.dart
    router/
      app_router.dart
  shared/
    theme/
      app_theme.dart
  features/
    onboarding/
      presentation/
        screens/
    dashboard/
      presentation/
        screens/
    maintenance/
      presentation/
        screens/
```

## 3) Conventions

- Noms techniques en anglais (`Vehicle`, `MaintenanceRecord`), textes UI en francais.
- Un ecran = une action principale.
- Widgets reutilisables dans `shared`.
- Regles de style centralisees dans `app_theme.dart`.

## 4) Flux principal

1. Authentification utilisateur.
2. Onboarding minimal (4 etapes).
3. Dashboard principal.
4. Ajout/consultation des entretiens.
5. Rappels et alertes.

## 5) Done minimum par feature

- ecran principal + etats loading/empty/error;
- branchement data V2;
- tests de base;
- lints sans erreur.
