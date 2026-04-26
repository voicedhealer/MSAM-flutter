import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../maintenance/domain/models/maintenance.dart';

class UpcomingMaintenance extends StatelessWidget {
  final List<Maintenance> maintenanceList;

  const UpcomingMaintenance({Key? key, required this.maintenanceList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: maintenanceList.map((maintenance) {
          final daysUntil = maintenance.date.difference(DateTime.now()).inDays;
          final isUrgent = daysUntil <= 7;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isUrgent ? AppColors.autoWarning : AppTheme.border(context),
                width: isUrgent ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: maintenance.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    maintenance.icon,
                    color: maintenance.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maintenance.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd MMM yyyy', 'fr_FR').format(maintenance.date),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isUrgent
                        ? AppColors.autoWarning.withValues(alpha: 0.1)
                        : AppColors.autoAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    daysUntil == 0
                        ? 'Aujourd\'hui'
                        : daysUntil == 1
                            ? 'Demain'
                            : '$daysUntil jours',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isUrgent ? AppColors.autoWarning : AppColors.autoAccent,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
