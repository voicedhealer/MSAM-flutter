import 'package:flutter/material.dart';

class Deal {
  final String id;
  final String? effinityId;
  final String title;
  final String description;
  final String discount;
  final String? code;
  final String category;
  final String? partnerName;
  final String? partnerLogo;
  final String? partnerImage;
  final String affiliateLink;
  final List<String> badges;
  final bool featured;
  final bool isActive;
  final DateTime? createdAt;

  const Deal({
    required this.id,
    this.effinityId,
    required this.title,
    required this.description,
    required this.discount,
    this.code,
    required this.category,
    this.partnerName,
    this.partnerLogo,
    this.partnerImage,
    required this.affiliateLink,
    this.badges = const [],
    this.featured = false,
    this.isActive = true,
    this.createdAt,
  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    final rawBadges = json['badges'];
    final badges = <String>[];
    if (rawBadges is List) {
      for (final b in rawBadges) {
        if (b is String && b.trim().isNotEmpty) badges.add(b);
      }
    }

    final createdRaw = json['created_at'];
    DateTime? createdAt;
    if (createdRaw is String) createdAt = DateTime.tryParse(createdRaw);

    return Deal(
      id: json['id'] as String,
      effinityId: json['effinity_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      discount: json['discount'] as String,
      code: json['code'] as String?,
      category: json['category'] as String,
      partnerName: json['partner_name'] as String?,
      partnerLogo: json['partner_logo'] as String?,
      partnerImage: json['partner_image'] as String?,
      affiliateLink: json['affiliate_link'] as String,
      badges: badges,
      featured: json['featured'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: createdAt,
    );
  }
}

IconData iconForDealCategory(String category) {
  switch (category.toLowerCase().trim()) {
    case 'pneus':
    case 'tires':
      return Icons.album;
    case 'entretien':
    case 'maintenance':
    case 'prestations':
      return Icons.build;
    case 'pieces detachees':
    case 'pieces':
    case 'pieces-detachees':
    case 'parts':
      return Icons.settings;
    case 'equipement':
    case 'equipment':
      return Icons.handyman;
    case 'assurance':
    case 'insurance':
      return Icons.shield_outlined;
    case 'lavage':
    case 'wash':
      return Icons.local_car_wash;
    case 'accessoires':
    case 'accessories':
      return Icons.car_repair;
    case 'places':
    case 'voyages':
    case 'transport':
      return Icons.train;
    case 'automoto':
    case 'auto':
    case 'moto':
      return Icons.directions_car;
    default:
      return Icons.local_offer_outlined;
  }
}
