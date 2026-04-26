import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/models/maintenance.dart';
import '../../../../shared/widgets/custom_input.dart';
import '../../../../shared/widgets/custom_button.dart';

class AddMaintenanceScreen extends StatefulWidget {
  final int currentMileage;

  const AddMaintenanceScreen({Key? key, required this.currentMileage})
      : super(key: key);

  @override
  State<AddMaintenanceScreen> createState() => _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends State<AddMaintenanceScreen> {
  String _selectedType = MaintenanceType.oil;
  final _titleController = TextEditingController();
  final _mileageController = TextEditingController();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> _types = [
    MaintenanceType.oil,
    MaintenanceType.tires,
    MaintenanceType.brakes,
    MaintenanceType.battery,
    MaintenanceType.inspection,
    MaintenanceType.other,
  ];

  @override
  void initState() {
    super.initState();
    _titleController.text = _selectedType;
    _mileageController.text = widget.currentMileage.toString();
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr', 'FR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.autoAccent,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleSave() {
    final mileage = int.tryParse(_mileageController.text) ?? widget.currentMileage;
    final cost = double.tryParse(_costController.text) ?? 0;

    final maintenance = Maintenance(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      title: _titleController.text.isEmpty ? _selectedType : _titleController.text,
      date: _selectedDate,
      mileage: mileage,
      cost: cost,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      status: _selectedDate.isAfter(DateTime.now())
          ? MaintenanceStatus.upcoming
          : MaintenanceStatus.done,
      icon: MaintenanceType.getIcon(_selectedType),
      color: MaintenanceType.getColor(_selectedType),
    );

    Navigator.pop(context, maintenance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.autoSurface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.autoTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nouvel entretien',
          style: TextStyle(
            color: AppColors.autoTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type d\'entretien',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.autoTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _types.map((type) {
                final isSelected = _selectedType == type;
                final color = MaintenanceType.getColor(type);
                final icon = MaintenanceType.getIcon(type);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                      if (_titleController.text.isEmpty ||
                          _types.contains(_titleController.text)) {
                        _titleController.text = type;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.1)
                          : AppColors.autoSurfaceElevated,
                      border: Border.all(
                        color: isSelected ? color : AppColors.autoBorder,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 18,
                          color: isSelected ? color : AppColors.autoTextSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          type,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? color : AppColors.autoTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            CustomInput(
              controller: _titleController,
              label: 'Titre',
              placeholder: 'Ex: Vidange moteur',
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.autoSurfaceElevated,
                  borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.autoTextHint, size: 20),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.autoTextHint,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('dd MMMM yyyy', 'fr_FR').format(_selectedDate),
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
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: _mileageController,
                    label: 'Kilometrage',
                    placeholder: '${widget.currentMileage}',
                    keyboardType: TextInputType.number,
                    icon: Icons.speed,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomInput(
                    controller: _costController,
                    label: 'Cout (EUR)',
                    placeholder: '0',
                    keyboardType: TextInputType.number,
                    icon: Icons.euro,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomInput(
              controller: _notesController,
              label: 'Notes (optionnel)',
              placeholder: 'Details supplementaires...',
              icon: Icons.sticky_note_2,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Enregistrer',
              onPressed: _handleSave,
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mileageController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
