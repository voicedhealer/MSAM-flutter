import 'package:flutter/material.dart';

class Maintenance {
  final String id;
  final String type;
  final String title;
  final DateTime date;
  final int mileage;
  final double cost;
  final String? notes;
  final MaintenanceStatus status;
  final IconData icon;
  final Color color;

  Maintenance({
    required this.id,
    required this.type,
    required this.title,
    required this.date,
    required this.mileage,
    required this.cost,
    this.notes,
    required this.status,
    required this.icon,
    required this.color,
  });
}

enum MaintenanceStatus {
  done,
  upcoming,
  overdue,
}

class MaintenanceType {
  static const String oil = 'Vidange';
  static const String tires = 'Pneus';
  static const String brakes = 'Freins';
  static const String battery = 'Batterie';
  static const String inspection = 'Controle technique';
  static const String other = 'Autre';

  static IconData getIcon(String type) {
    switch (type) {
      case oil:
        return Icons.oil_barrel;
      case tires:
        return Icons.album;
      case brakes:
        return Icons.stop_circle;
      case battery:
        return Icons.battery_charging_full;
      case inspection:
        return Icons.verified;
      default:
        return Icons.build;
    }
  }

  static Color getColor(String type) {
    switch (type) {
      case oil:
        return const Color(0xFFF59E0B);
      case tires:
        return const Color(0xFF6366F1);
      case brakes:
        return const Color(0xFFEF4444);
      case battery:
        return const Color(0xFF10B981);
      case inspection:
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }
}
