import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../vehicle/domain/models/vehicle.dart';
import '../../../maintenance/domain/models/maintenance.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/quick_stats.dart';
import '../widgets/upcoming_maintenance.dart';
import '../widgets/maintenance_history.dart';
import '../../../maintenance/presentation/screens/add_maintenance_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Vehicle vehicle;

  const DashboardScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Maintenance> _maintenanceList = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _maintenanceList = [
      Maintenance(
        id: '1',
        type: MaintenanceType.oil,
        title: 'Vidange moteur',
        date: DateTime.now().subtract(const Duration(days: 45)),
        mileage: 125000,
        cost: 85.0,
        notes: 'Huile 5W40 + filtre',
        status: MaintenanceStatus.done,
        icon: MaintenanceType.getIcon(MaintenanceType.oil),
        color: MaintenanceType.getColor(MaintenanceType.oil),
      ),
      Maintenance(
        id: '2',
        type: MaintenanceType.inspection,
        title: 'Controle technique',
        date: DateTime.now().add(const Duration(days: 15)),
        mileage: 130000,
        cost: 0,
        status: MaintenanceStatus.upcoming,
        icon: MaintenanceType.getIcon(MaintenanceType.inspection),
        color: MaintenanceType.getColor(MaintenanceType.inspection),
      ),
      Maintenance(
        id: '3',
        type: MaintenanceType.tires,
        title: 'Rotation des pneus',
        date: DateTime.now().subtract(const Duration(days: 120)),
        mileage: 118000,
        cost: 45.0,
        status: MaintenanceStatus.done,
        icon: MaintenanceType.getIcon(MaintenanceType.tires),
        color: MaintenanceType.getColor(MaintenanceType.tires),
      ),
      Maintenance(
        id: '4',
        type: MaintenanceType.brakes,
        title: 'Remplacement plaquettes',
        date: DateTime.now().subtract(const Duration(days: 180)),
        mileage: 115000,
        cost: 280.0,
        notes: 'Avant + arriere',
        status: MaintenanceStatus.done,
        icon: MaintenanceType.getIcon(MaintenanceType.brakes),
        color: MaintenanceType.getColor(MaintenanceType.brakes),
      ),
    ];
  }

  void _addMaintenance() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMaintenanceScreen(
          currentMileage: widget.vehicle.currentMileage,
        ),
      ),
    );

    if (result != null && result is Maintenance) {
      setState(() {
        _maintenanceList.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedMaintenance = _maintenanceList
        .where((m) => m.status == MaintenanceStatus.done)
        .toList();
    final upcomingMaintenance = _maintenanceList
        .where((m) => m.status == MaintenanceStatus.upcoming)
        .toList();

    final totalCost = completedMaintenance.fold<double>(
      0,
      (sum, item) => sum + item.cost,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.autoSurface,
              AppColors.autoSurfaceElevated,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mon Suivi',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: AppColors.autoTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Carnet d\'entretien digital',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.autoTextHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: VehicleCard(vehicle: widget.vehicle),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: QuickStats(
                    totalMaintenance: completedMaintenance.length,
                    totalCost: totalCost,
                    upcomingCount: upcomingMaintenance.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              if (upcomingMaintenance.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.autoAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'A venir',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.autoTextPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: UpcomingMaintenance(maintenanceList: upcomingMaintenance),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.autoSuccess,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Historique',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.autoTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(
                child: MaintenanceHistory(maintenanceList: completedMaintenance),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addMaintenance,
        backgroundColor: AppColors.autoAccent,
        elevation: 4,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Entretien',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
