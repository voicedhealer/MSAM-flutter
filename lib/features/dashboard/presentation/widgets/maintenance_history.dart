import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../maintenance/domain/models/maintenance.dart';

class MaintenanceHistory extends StatelessWidget {
  final List<Maintenance> maintenanceList;

  const MaintenanceHistory({Key? key, required this.maintenanceList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (maintenanceList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(48),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: AppTheme.textHint(context).withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun entretien pour le moment',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textHint(context),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: maintenanceList.asMap().entries.map((entry) {
          final index = entry.key;
          final maintenance = entry.value;
          final isLast = index == maintenanceList.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: maintenance.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 60,
                      color: AppTheme.border(context),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.border(context),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            maintenance.icon,
                            color: maintenance.color,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              maintenance.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary(context),
                              ),
                            ),
                          ),
                          if (maintenance.cost > 0)
                            Text(
                              '${maintenance.cost.toInt()}EUR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary(context),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppTheme.textHint(context),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd MMM yyyy', 'fr_FR').format(maintenance.date),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.speed,
                            size: 14,
                            color: AppTheme.textHint(context),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_formatNumber(maintenance.mileage)} km',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                      if (maintenance.notes != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.surface(context),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.sticky_note_2,
                                size: 16,
                                color: AppTheme.textHint(context),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  maintenance.notes!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }
}
