import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../vehicle/domain/services/vehicle_image_catalog.dart';

class VehicleData {
  final String brand;
  final String model;
  final int year;
  final String catalogImageUrl;
  final String? userImageUrl;

  VehicleData({
    required this.brand,
    required this.model,
    required this.year,
    required this.catalogImageUrl,
    this.userImageUrl,
  });
}

class Step2VehicleInfo extends StatefulWidget {
  final String plate;
  final Function(VehicleData) onNext;
  final VoidCallback onBack;
  final bool isExpressive;

  const Step2VehicleInfo({
    Key? key,
    required this.plate,
    required this.onNext,
    required this.onBack,
    required this.isExpressive,
  }) : super(key: key);

  @override
  State<Step2VehicleInfo> createState() => _Step2VehicleInfoState();
}

class _Step2VehicleInfoState extends State<Step2VehicleInfo> {
  bool _isLoading = true;
  VehicleData? _vehicleData;

  @override
  void initState() {
    super.initState();
    _loadVehicleData();
  }

  Future<void> _loadVehicleData() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      _vehicleData = VehicleData(
        brand: 'Peugeot',
        model: '308 GT',
        year: 2023,
        catalogImageUrl: VehicleImageCatalog.resolveImageUrl(
          brand: 'Peugeot',
          model: '308 GT',
          year: 2023,
        ),
      );
      _isLoading = false;
    });
  }

  void _onAddUserPhotoTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ajout photo perso bientot disponible'),
      ),
    );
  }

  void _handleConfirm() {
    if (_vehicleData != null) {
      widget.onNext(_vehicleData!);
    }
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final textPrimary = AppTheme.textPrimary(context);
    final textSecondary = AppTheme.textSecondary(context);
    final border = AppTheme.border(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 1,
          color: border,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textPrimary = AppTheme.textPrimary(context);
    final textSecondary = AppTheme.textSecondary(context);
    final textHint = AppTheme.textHint(context);
    final surfaceElevated = AppTheme.surfaceElevated(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isExpressive) ...[
          Center(
            child: Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                color: AppColors.autoSuccess.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.directions_car,
                color: AppColors.autoSuccess,
                size: 32,
              ),
            ),
          ),
        ],
        Text(
          'Vehicule trouve',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Confirmez les informations detectees',
          style: TextStyle(
            fontSize: 16,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        if (_isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.autoAccent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Recherche en cours...',
                    style: TextStyle(color: textHint),
                  ),
                ],
              ),
            ),
          )
        else ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                _vehicleData!.catalogImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: surfaceElevated,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.directions_car,
                    size: 48,
                    color: textSecondary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _onAddUserPhotoTap,
                  icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                  label: const Text('Ajouter ma photo'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.border(context)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surfaceElevated,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            ),
            child: Column(
              children: [
                _buildInfoRow(context, 'Plaque', widget.plate),
                _buildInfoRow(context, 'Marque', _vehicleData!.brand),
                _buildInfoRow(context, 'Modele', _vehicleData!.model),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Annee',
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                    Text(
                      '${_vehicleData!.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.autoSuccess,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Informations verifiees automatiquement',
                style: TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 32),
        CustomButton(
          text: 'Confirmer',
          onPressed: _isLoading ? null : _handleConfirm,
          fullWidth: true,
        ),
        const SizedBox(height: 12),
        CustomButton(
          text: 'Retour',
          onPressed: widget.onBack,
          variant: ButtonVariant.ghost,
          fullWidth: true,
        ),
      ],
    );
  }
}
