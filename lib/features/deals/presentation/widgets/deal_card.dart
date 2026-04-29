import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../domain/models/deal.dart';

class DealCard extends StatefulWidget {
  final Deal deal;

  const DealCard({super.key, required this.deal});

  @override
  State<DealCard> createState() => _DealCardState();
}

class _DealCardState extends State<DealCard> {
  static const _shortDiscountThreshold = 16;
  static const _descriptionTruncateThreshold = 100;
  static const _descriptionMaxLines = 2;
  static const _thumbnailSize = 110.0;

  bool _descriptionExpanded = false;

  Future<void> _openAffiliateUrl() async {
    final uri = Uri.tryParse(widget.deal.affiliateLink);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir le lien partenaire.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;
    final isShortDiscount = deal.discount.length <= _shortDiscountThreshold;
    final showPartnerSubtitle = deal.partnerName != null &&
        deal.partnerName!.trim().toLowerCase() !=
            deal.title.trim().toLowerCase();
    final shouldTruncateDescription =
        deal.description.length > _descriptionTruncateThreshold;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(
          color: deal.featured
              ? AppColors.autoAccent.withValues(alpha: 0.6)
              : AppTheme.border(context),
          width: deal.featured ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _openAffiliateUrl,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DealThumbnail(deal: deal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showPartnerSubtitle)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                deal.partnerName!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  deal.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    color: AppTheme.textPrimary(context),
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isShortDiscount) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.ctaGradient,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    deal.discount,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                iconForDealCategory(deal.category),
                                size: 12,
                                color: AppTheme.textHint(context),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  deal.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textHint(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isShortDiscount) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.ctaGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    deal.discount,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                deal.description,
                maxLines: shouldTruncateDescription && !_descriptionExpanded
                    ? _descriptionMaxLines
                    : null,
                overflow: shouldTruncateDescription && !_descriptionExpanded
                    ? TextOverflow.ellipsis
                    : TextOverflow.clip,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: AppTheme.textSecondary(context),
                ),
              ),
              if (shouldTruncateDescription)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(
                        () => _descriptionExpanded = !_descriptionExpanded),
                    child: Text(
                      _descriptionExpanded ? 'Voir moins' : 'Voir plus',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.autoAccent,
                      ),
                    ),
                  ),
                ),
              if (deal.badges.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: deal.badges
                      .map((b) => _BadgeChip(label: b))
                      .toList(),
                ),
              ],
              if (deal.code != null && deal.code!.isNotEmpty) ...[
                const SizedBox(height: 10),
                _PromoCode(code: deal.code!),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  if (deal.featured) ...[
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.autoWarning,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Offre vedette',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.autoWarning,
                      ),
                    ),
                  ],
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _openAffiliateUrl,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.autoAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: const Text(
                      'En profiter',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DealThumbnail extends StatelessWidget {
  final Deal deal;

  const _DealThumbnail({required this.deal});

  bool get _hasImage =>
      deal.partnerImage != null && deal.partnerImage!.startsWith('http');

  String get _initials {
    final source = deal.partnerName ?? deal.title;
    final parts = source
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: _DealCardState._thumbnailSize,
        height: _DealCardState._thumbnailSize,
        child: _hasImage ? _buildImage(context) : _buildInitials(),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Image.network(
        deal.partnerImage!,
        fit: BoxFit.cover,
        width: _DealCardState._thumbnailSize,
        height: _DealCardState._thumbnailSize,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
        errorBuilder: (_, __, ___) => _buildInitials(),
      ),
    );
  }

  Widget _buildInitials() {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.ctaGradient),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: const TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;

  const _BadgeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.autoAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.autoAccent,
        ),
      ),
    );
  }
}

class _PromoCode extends StatelessWidget {
  final String code;

  const _PromoCode({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.autoAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 14,
            color: AppTheme.textSecondary(context),
          ),
          const SizedBox(width: 6),
          Text(
            'Code',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textHint(context),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              code,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppTheme.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
