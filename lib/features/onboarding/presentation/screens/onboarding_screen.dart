import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding MSAM')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Etape 1/4 - Plaque',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'Squelette pret: plaque -> vehicule -> identite -> profil optionnel.',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRouter.dashboard);
              },
              child: const Text('Continuer'),
            ),
          ],
        ),
      ),
    );
  }
}
