import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';

class QuickStats extends StatelessWidget {
  final int totalMaintenance;
  final double totalCost;
  final int upcomingCount;

  const QuickStats({
    Key? key,
    required this.totalMaintenance,
    required this.totalCost,
    required this.upcomingCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.build_circle,
            value: '$totalMaintenance',
            label: 'Realises',
            color: AppColors.autoSuccess,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.euro,
            value: '${totalCost.toInt()}EUR',
            label: 'Depenses',
            color: AppColors.autoWarning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.event,
            value: '$upcomingCount',
            label: 'A venir',
            color: AppColors.autoAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
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
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.autoTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.autoTextHint,
            ),
          ),
        ],
      ),
    );
  }
}
