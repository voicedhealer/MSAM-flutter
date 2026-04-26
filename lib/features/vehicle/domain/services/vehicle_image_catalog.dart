class VehicleImageCatalog {
  // Version legere: catalogue local en code.
  // Evolution future: table DB + CDN, meme API de resolution.
  static const Map<String, String> _catalog = {
    // Peugeot 308 (exemple proche du besoin)
    'peugeot|308 gt':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Peugeot_308_II_Facelift_blue_IMG_3747.jpg/640px-Peugeot_308_II_Facelift_blue_IMG_3747.jpg',
    'peugeot|308':
        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Peugeot_308_II_Facelift_blue_IMG_3747.jpg/640px-Peugeot_308_II_Facelift_blue_IMG_3747.jpg',
  };

  static const String _fallbackImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Car_icon.svg/512px-Car_icon.svg.png';

  static String resolveImageUrl({
    required String brand,
    required String model,
    required int year,
  }) {
    final normalizedBrand = brand.trim().toLowerCase();
    final normalizedModel = model.trim().toLowerCase();

    final exactKey = '$normalizedBrand|$normalizedModel';
    if (_catalog.containsKey(exactKey)) {
      return _catalog[exactKey]!;
    }

    // Fallback "modele racine" (ex: "308 GT" -> "308")
    final modelRoot = normalizedModel.split(' ').first;
    final rootKey = '$normalizedBrand|$modelRoot';
    if (_catalog.containsKey(rootKey)) {
      return _catalog[rootKey]!;
    }

    return _fallbackImageUrl;
  }
}
