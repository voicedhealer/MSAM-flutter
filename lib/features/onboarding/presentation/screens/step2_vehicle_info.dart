import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/theme/app_theme.dart';

class VehicleData {
  final String brand;
  final String model;
  final int year;

  VehicleData({
    required this.brand,
    required this.model,
    required this.year,
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
      );
      _isLoading = false;
    });
  }

  void _handleConfirm() {
    if (_vehicleData != null) {
      widget.onNext(_vehicleData!);
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.autoTextSecondary,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.autoTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 1,
          color: AppColors.autoBorder,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        const Text(
          'Vehicule trouve',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: AppColors.autoTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Confirmez les informations detectees',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.autoTextSecondary,
          ),
        ),
        const SizedBox(height: 24),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: AppColors.autoAccent,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Recherche en cours...',
                    style: TextStyle(color: AppColors.autoTextHint),
                  ),
                ],
              ),
            ),
          )
        else ...[
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.autoSurfaceElevated,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            ),
            child: Column(
              children: [
                _buildInfoRow('Plaque', widget.plate),
                _buildInfoRow('Marque', _vehicleData!.brand),
                _buildInfoRow('Modele', _vehicleData!.model),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Annee',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.autoTextSecondary,
                      ),
                    ),
                    Text(
                      '${_vehicleData!.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.autoTextPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.autoSuccess,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Informations verifiees automatiquement',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.autoSuccess,
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
