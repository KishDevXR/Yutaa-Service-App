import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:yutaa_customer_app/features/bookings/data/bookings_data.dart';
import 'package:yutaa_customer_app/features/bookings/models/booking_model.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  // Listen to repository changes
  @override
  void initState() {
    super.initState();
    BookingsRepository().addListener(_onRepoChange);
  }

  @override
  void dispose() {
    BookingsRepository().removeListener(_onRepoChange);
    super.dispose();
  }

  void _onRepoChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookings = BookingsRepository().bookings;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('My Bookings', style: TextStyle(color: theme.colorScheme.onBackground, fontWeight: FontWeight.bold)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 60, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('No bookings found', style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6))),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return GestureDetector(
                  onTap: () {
                     context.push('/booking-status', extra: booking.id);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMM d, yyyy').format(booking.date),
                              style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6), fontSize: 13),
                            ),
                            _buildStatusChip(booking.status),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          booking.service.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 8),
                         Row(
                           children: [
                             const Icon(Icons.access_time, size: 14, color: Colors.grey),
                             const SizedBox(width: 4),
                             Text(booking.timeSlot, style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.8))),
                           ],
                         ),
                         const SizedBox(height: 12),
                         Divider(color: Colors.grey.shade200),
                         const SizedBox(height: 8),
                         Text(
                           '${booking.partnerStatuses.length} Professionals Requested',
                           style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.primaryPurple),
                         )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color color;
    String label;

    switch (status) {
      case BookingStatus.waiting:
        color = Colors.orange;
        label = 'Waiting';
        break;
      case BookingStatus.approved:
        color = Colors.blue;
        label = 'Action Required';
        break;
      case BookingStatus.in_progress:
        color = Colors.green;
        label = 'In Progress';
        break;
      case BookingStatus.completed:
        color = Colors.grey;
        label = 'Completed';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
