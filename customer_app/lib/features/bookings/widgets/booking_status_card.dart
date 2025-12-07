import 'package:flutter/material.dart';
import 'package:yutaa_customer_app/features/bookings/models/booking_model.dart';
import 'package:yutaa_customer_app/features/booking/models/partner_model.dart';
import 'package:yutaa_customer_app/features/bookings/data/bookings_data.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';

class BookingStatusCard extends StatelessWidget {
  final PartnerBookingStatus partnerStatus;
  final BookingModel booking;

  const BookingStatusCard({
    super.key,
    required this.partnerStatus,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final partner = partnerStatus.partner;
    final status = partnerStatus.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
        ),
        boxShadow: [
          if (!isDark)
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
              CircleAvatar(
                radius: 28,
                backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                child: partner.imagePath.isNotEmpty
                    ? ClipOval(
                        child: Image.asset(
                          partner.imagePath,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, size: 28, color: Colors.grey),
                          fit: BoxFit.cover,
                          width: 56,
                          height: 56,
                        ),
                      )
                    : const Icon(Icons.person, size: 28, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          partner.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        _buildStatusChip(context),
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
                    // Price and Distance
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          partner.price,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: theme.colorScheme.onBackground.withOpacity(0.5)),
                             Text(
                              ' ${partner.distance} km',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onBackground.withOpacity(0.6),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Action Buttons based on status
          if (status == PartnerRequestStatus.approved && booking.status == BookingStatus.approved) ...[
             const SizedBox(height: 16),
             Divider(color: isDark ? Colors.white10 : Colors.grey.shade200),
             const SizedBox(height: 8),
             Row(
               children: [
                 Expanded(
                   child: OutlinedButton(
                     onPressed: () {
                        BookingsRepository().userDeclinePartner(booking.id, partner.id);
                     },
                     style: OutlinedButton.styleFrom(
                       foregroundColor: Colors.red,
                       side: const BorderSide(color: Colors.red),
                       padding: const EdgeInsets.symmetric(vertical: 12),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     ),
                     child: const Text('Decline', style: TextStyle(fontWeight: FontWeight.bold)),
                   ),
                 ),
                 const SizedBox(width: 12),
                 Expanded(
                   child: ElevatedButton(
                     onPressed: () {
                        BookingsRepository().userConfirmPartner(booking.id, partner.id);
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.green,
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(vertical: 12),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     ),
                     child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
                   ),
                 ),
               ],
             )
          ]
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    Color bgColor;
    Color textColor;
    String text;

    switch (partnerStatus.status) {
      case PartnerRequestStatus.waiting:
        bgColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange;
        text = "Waiting";
        break;
      case PartnerRequestStatus.approved:
        bgColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        text = "Accepted";
        break;
      case PartnerRequestStatus.cancelled:
        bgColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
        text = "Cancelled";
        break;
      case PartnerRequestStatus.rejected:
        bgColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
        text = "Declined";
        break;
      default:
        bgColor = Colors.grey.withOpacity(0.1);
        textColor = Colors.grey;
        text = "Unknown";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
