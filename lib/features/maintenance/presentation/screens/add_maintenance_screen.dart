import 'package:flutter/material.dart';

class AddMaintenanceScreen extends StatelessWidget {
  const AddMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un entretien')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Type entretien',
                hintText: 'Vidange, freins, pneus...',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Kilometrage',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Cout (EUR)',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}
