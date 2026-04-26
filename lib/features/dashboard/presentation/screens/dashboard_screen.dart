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
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const DashboardScreen({
    super.key,
    required this.vehicle,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Maintenance> _maintenanceList = [];
  int _selectedTabIndex = 0;

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

  List<Maintenance> get _completedMaintenance => _maintenanceList
      .where((m) => m.status == MaintenanceStatus.done)
      .toList();

  List<Maintenance> get _upcomingMaintenance => _maintenanceList
      .where((m) => m.status == MaintenanceStatus.upcoming)
      .toList();

  double get _totalCost =>
      _completedMaintenance.fold<double>(0, (sum, item) => sum + item.cost);

  double get _averageCost =>
      _completedMaintenance.isEmpty ? 0 : _totalCost / _completedMaintenance.length;

  double get _costPerKm {
    if (widget.vehicle.currentMileage <= 0) return 0;
    return _totalCost / widget.vehicle.currentMileage;
  }

  Map<String, int> get _maintenanceByType {
    final map = <String, int>{};
    for (final item in _completedMaintenance) {
      map.update(item.type, (value) => value + 1, ifAbsent: () => 1);
    }
    return map;
  }

  List<Maintenance> get _aiSuggestions {
    return _upcomingMaintenance.where((item) {
      final remainingDays = item.date.difference(DateTime.now()).inDays;
      return remainingDays <= 30;
    }).toList();
  }

  void _showThemeModeSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Apparence',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('Choisir Clair, Sombre ou Systeme'),
              ),
              ListTile(
                title: const Text('Mode clair'),
                trailing: widget.currentThemeMode == ThemeMode.light
                    ? const Icon(Icons.check, color: AppColors.autoAccent)
                    : null,
                onTap: () {
                  widget.onThemeModeChanged(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Mode sombre'),
                trailing: widget.currentThemeMode == ThemeMode.dark
                    ? const Icon(Icons.check, color: AppColors.autoAccent)
                    : null,
                onTap: () {
                  widget.onThemeModeChanged(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Suivre l appareil'),
                trailing: widget.currentThemeMode == ThemeMode.system
                    ? const Icon(Icons.check, color: AppColors.autoAccent)
                    : null,
                onTap: () {
                  widget.onThemeModeChanged(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(BuildContext context, String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary(context),
          ),
        ),
      ],
    );
  }

  Widget _buildAISuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Suggestions IA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.autoWarning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Orange',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.autoWarning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_aiSuggestions.isEmpty)
              Text(
                'Aucune suggestion prioritaire pour le moment.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary(context),
                ),
              )
            else
              ..._aiSuggestions.map((item) {
                final days = item.date.difference(DateTime.now()).inDays;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: AppColors.autoWarning,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${item.title} a prevoir dans $days jours',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textPrimary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mon Suivi Auto Moto',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Carnet d\'entretien digital',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textHint(context),
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
              totalMaintenance: _completedMaintenance.length,
              totalCost: _totalCost,
              upcomingCount: _upcomingMaintenance.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(child: _buildAISuggestions(context)),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        if (_upcomingMaintenance.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _sectionTitle(context, 'A venir', AppColors.autoAccent),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(
            child: UpcomingMaintenance(maintenanceList: _upcomingMaintenance),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _sectionTitle(context, 'Historique', AppColors.autoSuccess),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: MaintenanceHistory(maintenanceList: _completedMaintenance),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.autoAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.autoAccent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textHint(context),
                  ),
                ),
                const SizedBox(height: 2),
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
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDistribution(BuildContext context) {
    if (_maintenanceByType.isEmpty) {
      return Text(
        'Pas encore assez de donnees pour afficher la repartition.',
        style: TextStyle(
          fontSize: 14,
          color: AppTheme.textSecondary(context),
        ),
      );
    }

    final total = _completedMaintenance.length;
    return Column(
      children: _maintenanceByType.entries.map((entry) {
        final percentage = (entry.value / total * 100).round();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: entry.value / total,
                    minHeight: 10,
                    backgroundColor: AppTheme.border(context),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.autoAccent),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary(context),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary(context),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Vue des couts et tendances d\'entretien',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary(context),
            ),
          ),
          const SizedBox(height: 20),
          _statCard(
            context,
            'Cout total',
            '${_totalCost.toStringAsFixed(0)}EUR',
            '${_completedMaintenance.length} entretiens realises',
            Icons.euro,
          ),
          const SizedBox(height: 12),
          _statCard(
            context,
            'Cout / km',
            '${_costPerKm.toStringAsFixed(4)} EUR/km',
            'Moyenne: ${_averageCost.toStringAsFixed(0)}EUR par entretien',
            Icons.speed,
          ),
          const SizedBox(height: 24),
          Text(
            'Repartition par type',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary(context),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border(context)),
            ),
            child: _buildTypeDistribution(context),
          ),
        ],
      ),
    );
  }

  Widget _profileItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.textSecondary(context)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppTheme.textHint(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profil',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary(context),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Infos vehicule',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Plaque: ${widget.vehicle.plate}',
                  style: TextStyle(color: AppTheme.textPrimary(context)),
                ),
                Text(
                  'Modele: ${widget.vehicle.brand} ${widget.vehicle.model}',
                  style: TextStyle(color: AppTheme.textSecondary(context)),
                ),
                Text(
                  'Annee: ${widget.vehicle.year}',
                  style: TextStyle(color: AppTheme.textSecondary(context)),
                ),
                Text(
                  'Kilometrage: ${widget.vehicle.currentMileage} km',
                  style: TextStyle(color: AppTheme.textSecondary(context)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Parametres',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary(context),
            ),
          ),
          const SizedBox(height: 10),
          _profileItem(
            context,
            Icons.palette_outlined,
            'Apparence',
            'Clair, Sombre ou Systeme',
            onTap: _showThemeModeSheet,
          ),
          _profileItem(context, Icons.notifications, 'Notifications', 'Rappels et alertes'),
          _profileItem(context, Icons.picture_as_pdf, 'Export PDF', 'Exporter le carnet'),
          _profileItem(context, Icons.lock, 'Confidentialite', 'Droits et donnees'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabViews = [
      _buildHomeTab(context),
      _buildStatsTab(context),
      _buildProfileTab(context),
    ];

    return Scaffold(
      backgroundColor: AppTheme.surface(context),
      body: SafeArea(child: tabViews[_selectedTabIndex]),
      floatingActionButton: _selectedTabIndex == 0
          ? FloatingActionButton.extended(
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
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedTabIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
