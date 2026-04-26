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
            context,
            icon: Icons.build_circle,
            value: '$totalMaintenance',
            label: 'Realises',
            color: AppColors.autoSuccess,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.euro,
            value: '${totalCost.toInt()}EUR',
            label: 'Depenses',
            color: AppColors.autoWarning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.event,
            value: '$upcomingCount',
            label: 'A venir',
            color: AppColors.autoAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
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
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textHint(context),
            ),
          ),
        ],
      ),
    );
  }
}
