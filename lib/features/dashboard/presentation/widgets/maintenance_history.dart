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
                color: AppColors.autoTextHint.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun entretien pour le moment',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.autoTextHint,
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
                      color: AppColors.autoBorder,
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
                    color: AppColors.autoSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.autoBorder,
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.autoTextPrimary,
                              ),
                            ),
                          ),
                          if (maintenance.cost > 0)
                            Text(
                              '${maintenance.cost.toInt()}EUR',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.autoTextPrimary,
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
                            color: AppColors.autoTextHint,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd MMM yyyy', 'fr_FR').format(maintenance.date),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.autoTextSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.speed,
                            size: 14,
                            color: AppColors.autoTextHint,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_formatNumber(maintenance.mileage)} km',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.autoTextSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (maintenance.notes != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.autoSurfaceElevated,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.sticky_note_2,
                                size: 16,
                                color: AppColors.autoTextHint,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  maintenance.notes!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.autoTextSecondary,
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
