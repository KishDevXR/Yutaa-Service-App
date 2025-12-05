import 'package:flutter/material.dart';
import 'package:yutaa_customer_app/features/booking/models/partner_model.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';

class PartnerCard extends StatelessWidget {
  final PartnerModel partner;
  final bool isSelected;
  final VoidCallback? onSelect;

  const PartnerCard({
    super.key,
    required this.partner,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isSelected 
                ? AppTheme.primaryPurple 
                : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200),
            width: isSelected ? 2 : 1),
        boxShadow: [
          if (!isDark && !isSelected)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    // Use a generic Asset or Icon if image doesn't exist
                    child: partner.imagePath.isNotEmpty
                        ? ClipOval(
                            child: Image.asset(
                              partner.imagePath,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 30, color: Colors.grey),
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                          )
                        : const Icon(Icons.person, size: 30, color: Colors.grey),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green, // Online / Verified indicator
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user, size: 10, color: Colors.white),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          partner.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        if (partner.isTopPro) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.amber),
                            ),
                            child: const Text(
                              'Top Pro',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(
                          ' ${partner.rating} (${partner.reviewCount})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onBackground.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          ' • ${partner.jobCount} jobs',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: theme.colorScheme.onBackground.withOpacity(0.5)),
                        Text(
                          ' ${partner.distance} km away',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time,
                            size: 14, color: theme.colorScheme.onBackground.withOpacity(0.5)),
                        Text(
                          ' ${partner.duration}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? Colors.white10 : Colors.grey.shade200),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Price',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onBackground.withOpacity(0.5),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        partner.price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      if (partner.isPremium) ...[
                        const SizedBox(width: 8),
                         Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Premium',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ]
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? Colors.white : AppTheme.primaryPurple,
                  foregroundColor: isSelected ? AppTheme.primaryPurple : Colors.white,
                  side: isSelected ? const BorderSide(color: AppTheme.primaryPurple) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(isSelected ? 'Selected' : 'Select'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
