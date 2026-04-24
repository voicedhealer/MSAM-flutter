# Mon-Suivi-Auto-Moto (MSAM)

Charte projet et design system de reference pour l'application mobile Flutter iOS/Android.

## 1) Vision produit

MSAM est un carnet d'entretien numerique auto/moto (thermique et electrique) qui remplace le carnet papier.

Objectifs principaux:
- minimiser les interactions utilisateur;
- maximiser les informations utiles au bon moment;
- offrir une experience moderne, rassurante et rapide.

Promesse:
- "Simple, rapide, moderne, fonctionnel, avec effet wahou."

## 2) Principes UX non negociables

- **Zero friction:** un ecran = une action principale.
- **Vitesse:** parcours onboarding en 30 a 60 secondes.
- **Clarte:** information prioritaire visible sans effort.
- **Progression:** etapes explicites (`1/4`, `2/4`, etc.).
- **Tolérance:** possibilite de passer les etapes facultatives (`Plus tard`).
- **Confiance:** microcopy courte et rassurante.
- **Accessibilite:** contrastes conformes, zones tactiles >= 48px.

## 3) Structure fonctionnelle de base

### Onboarding (minimal)
1. Plaque d'immatriculation (obligatoire)
2. Auto-remplissage vehicule + confirmation rapide
3. Identite minimale (prenom, email)
4. Profil facultatif (kilometrage, usage, rappels) avec `Plus tard`

### Dashboard
- Carte vehicule hero (plaque, modele, energie, kilometrage)
- Statistiques rapides (entretiens, cout total, prochaines echeances)
- Section "A venir" avec urgence visuelle
- Historique chronologique des entretiens
- Ajout d'entretien en action flottante rapide

## 4) Charte graphique (Design System V1)

### 4.1 Couleurs

Palette de base:
- **Primary:** `#2563EB` (bleu premium)
- **Primary Dark:** `#1E40AF`
- **Accent:** `#06B6D4` (cyan moderne)
- **Success:** `#16A34A`
- **Warning:** `#F59E0B`
- **Error:** `#DC2626`
- **Background:** `#F8FAFC`
- **Surface:** `#FFFFFF`
- **Text Primary:** `#0F172A`
- **Text Secondary:** `#475569`
- **Border:** `#E2E8F0`

Regles:
- ratio de contraste lisible en toutes circonstances;
- les alertes critiques utilisent `Error` ou `Warning` uniquement;
- ne pas multiplier les couleurs metier hors systeme.

### 4.2 Typographie

Police recommandee:
- iOS: `SF Pro`
- Android: `Roboto`
- fallback Flutter: police systeme par defaut

Echelle:
- `Display`: 28/34, semi-bold
- `H1`: 24/30, semi-bold
- `H2`: 20/26, semi-bold
- `Body`: 16/24, regular
- `Body Small`: 14/20, regular
- `Caption`: 12/16, medium

Regles:
- pas de texte inferieur a 12px;
- lignes courtes et scannables;
- titres orientés action ("Ajouter un entretien", "Verifier le vehicule").

### 4.3 Espacements et grille

Systeme 8pt:
- `4, 8, 12, 16, 24, 32, 40`

Regles:
- marges ecran: 16 ou 20;
- espacement vertical principal entre sections: 24;
- densite visuelle legere pour prioriser la lisibilite.

### 4.4 Rayons, ombres et elevation

- Radius: `12` (inputs/cards), `16` (cards hero), `24` (cta pill)
- Ombres subtiles, jamais agressives
- Elevation reservee aux elements interactifs prioritaires

### 4.5 Boutons et champs

Boutons:
- `Primary`: action principale, plein large en bas d'ecran
- `Secondary`: action de support
- `Ghost`: action neutre/secondaire (`Plus tard`)

Champs:
- labels toujours visibles;
- aide contextuelle courte;
- erreurs en langage humain (pas technique).

## 5) Composants UI de reference

- `MSAMButton` (primary/secondary/ghost)
- `MSAMInput` (label, hint, error, icon)
- `MSAMProgress` (minimal/expressive)
- `VehicleHeroCard`
- `QuickStatCard`
- `UpcomingMaintenanceCard`
- `MaintenanceTimelineItem`

Regle: tout nouveau composant reutilisable doit etre ajoute au design system avant duplication.

## 6) Ton editorial et microcopy

- style direct, simple, positif;
- phrases courtes;
- vocabulaire utilisateur (pas jargon technique);
- toujours orienter vers l'action suivante.

Exemples:
- "On a retrouve votre vehicule."
- "Ajoutez votre premier entretien en 15 secondes."
- "Pas maintenant? Vous pourrez le faire plus tard."

## 7) Regles techniques Flutter

- architecture modulaire par domaine (`features/onboarding`, `features/dashboard`, etc.);
- separation claire UI / logique / donnees;
- naming explicite et constant (anglais technique, libelles utilisateur en francais);
- composants atomiques reutilisables avant ecrans complexes;
- lint strict + formatage automatique;
- aucune logique metier dans les widgets de presentation.

## 8) Strategie base de donnees (Supabase) - Option A retenue

Decision:
- conserver le meme projet Supabase pour garder la continuite utilisateur;
- brancher l'app Flutter uniquement sur un schema **V2**;
- migrer les donnees V1 vers V2 de maniere controlee.

Cadre recommande:
1. garder `auth.users` existant;
2. creer les tables V2 (`profiles_v2`, `vehicles_v2`, `maintenances_v2`, `reminders_v2`);
3. appliquer les policies RLS des la creation;
4. ecrire un script de migration V1 -> V2;
5. tester la migration sur un jeu de donnees de preproduction;
6. connecter l'app Flutter uniquement sur V2;
7. monitorer les erreurs et valider les comptes migres.

Regles de securite:
- RLS obligatoire sur toutes les tables applicatives;
- acces strictement scope a l'utilisateur connecte;
- aucun secret Supabase dans le code client.

## 9) Definition of Done (DoD) pour chaque ecran

Un ecran est "termine" si:
- UX conforme aux principes de la section 2;
- design conforme a la section 4;
- accessibilite verifiee (contrastes + touch targets);
- etats de chargement / vide / erreur geres;
- analytics essentiels poses;
- lints et tests de base passent.

## 10) Gouvernance

Avant toute nouvelle fonctionnalite:
- verifier la coherence avec cette charte;
- documenter les exceptions;
- eviter les ecarts visuels/UX non justifies.

Cette charte est la reference unique pour aligner design, produit et implementation mobile.
