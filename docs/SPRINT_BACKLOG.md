# Backlog Sprint MSAM

Backlog pragmatique en 4 sprints (2 semaines possibles en mode accelere, sinon 4 semaines).

## Sprint 1 - Fondations

- [ ] Initialiser architecture Flutter (`core`, `shared`, `features`)
- [ ] Configurer theme global et tokens design
- [ ] Integrer Supabase Flutter (env dev/prod)
- [ ] Creer schema SQL V2 (profiles, vehicles, maintenances, reminders)
- [ ] Activer RLS et policies par utilisateur
- [ ] Setup lint/format + CI de base

## Sprint 2 - Onboarding et Auth

- [ ] Auth email (magic link ou mot de passe selon choix final)
- [ ] Onboarding etape 1: plaque
- [ ] Onboarding etape 2: confirmation vehicule
- [ ] Onboarding etape 3: identite minimale
- [ ] Onboarding etape 4: profil optionnel + "Plus tard"
- [ ] Persistance des donnees onboarding en V2

## Sprint 3 - Dashboard et Entretiens

- [ ] Dashboard: carte vehicule + stats + section a venir
- [ ] Historique entretiens (timeline)
- [ ] Ecran ajout entretien rapide
- [ ] Edition/suppression entretien
- [ ] Recalcul stats et prochaines echeances
- [ ] Etats vides intelligents (guidage utilisateur)

## Sprint 4 - Migration, Qualite, Release

- [ ] Script migration V1 -> V2 (option A)
- [ ] Validation des comptes migres
- [ ] Tests parcours critiques (onboarding -> dashboard -> ajout)
- [ ] QA iOS/Android (accessibilite/perf)
- [ ] Instrumentation analytics/crash
- [ ] Checklist release TestFlight + Play Internal

## Priorites transverses

- P0: onboarding rapide, dashboard lisible, ajout entretien en moins de 15 sec
- P1: rappels intelligents, experience premium
- P2: optimisations visuelles et micro-animations
