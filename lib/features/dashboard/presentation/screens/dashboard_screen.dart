import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Suivi Auto Moto')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRouter.addMaintenance),
        label: const Text('Entretien'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              title: Text('Vehicule principal'),
              subtitle: Text('AA-123-BB - Modele a brancher'),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              title: Text('A venir'),
              subtitle: Text('Prochain entretien: dans 20 jours'),
            ),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              title: Text('Historique'),
              subtitle: Text('Aucun entretien pour le moment'),
            ),
          ),
        ],
      ),
    );
  }
}
