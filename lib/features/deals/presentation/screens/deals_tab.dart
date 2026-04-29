import 'package:flutter/material.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../data/deals_repository.dart';
import '../../domain/models/deal.dart';
import '../widgets/deal_card.dart';

class DealsTab extends StatefulWidget {
  const DealsTab({super.key});

  @override
  State<DealsTab> createState() => _DealsTabState();
}

class _DealsTabState extends State<DealsTab> {
  final DealsRepository _repository = DealsRepository();
  late Future<List<Deal>> _future;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _future = _repository.fetchActiveDeals();
  }

  Future<void> _refresh() async {
    final next = _repository.fetchActiveDeals();
    setState(() => _future = next);
    await next;
  }

  List<String> _categoriesFrom(List<Deal> deals) {
    final seen = <String>{};
    final ordered = <String>[];
    for (final d in deals) {
      if (seen.add(d.category)) ordered.add(d.category);
    }
    return ordered;
  }

  List<Deal> _applyFilter(List<Deal> deals) {
    if (_selectedCategory == null) return deals;
    return deals.where((d) => d.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Deal>>(
        future: _future,
        builder: (context, snapshot) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bons plans',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Offres exclusives de nos partenaires',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textHint(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ..._buildBody(snapshot),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildBody(AsyncSnapshot<List<Deal>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (snapshot.hasError) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _ErrorState(
            message: snapshot.error.toString(),
            onRetry: _refresh,
          ),
        ),
      ];
    }

    final deals = snapshot.data ?? const <Deal>[];
    if (deals.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Aucun bon plan disponible pour le moment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary(context),
                ),
              ),
            ),
          ),
        ),
      ];
    }

    final categories = _categoriesFrom(deals);
    final filtered = _applyFilter(deals);

    return [
      SliverToBoxAdapter(
        child: SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _CategoryChip(
                label: 'Tout',
                icon: Icons.local_offer_outlined,
                selected: _selectedCategory == null,
                onTap: () => setState(() => _selectedCategory = null),
              ),
              ...categories.map(
                (cat) => _CategoryChip(
                  label: cat,
                  icon: iconForDealCategory(cat),
                  selected: _selectedCategory == cat,
                  onTap: () => setState(() => _selectedCategory = cat),
                ),
              ),
            ],
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 8)),
      if (filtered.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'Aucun bon plan dans cette categorie.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary(context),
                ),
              ),
            ),
          ),
        )
      else
        SliverList.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) => DealCard(deal: filtered[index]),
        ),
    ];
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.autoAccent
                  : AppTheme.surfaceElevated(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? AppColors.autoAccent : AppTheme.border(context),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : AppTheme.textSecondary(context),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppTheme.textPrimary(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 40,
              color: AppTheme.textHint(context),
            ),
            const SizedBox(height: 12),
            Text(
              'Impossible de charger les bons plans.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary(context),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textHint(context),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => onRetry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.autoAccent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Reessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
