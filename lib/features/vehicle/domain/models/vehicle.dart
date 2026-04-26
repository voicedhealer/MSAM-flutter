class Vehicle {
  final String plate;
  final String brand;
  final String model;
  final int year;
  final int currentMileage;
  final String type;
  final String fuelType;
  final String? catalogImageUrl;
  final String? userImageUrl;

  Vehicle({
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.currentMileage,
    required this.type,
    required this.fuelType,
    this.catalogImageUrl,
    this.userImageUrl,
  });

  String? get displayImageUrl => userImageUrl ?? catalogImageUrl;
}
