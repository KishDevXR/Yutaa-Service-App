import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yutaa_customer_app/features/bookings/data/bookings_data.dart';
import 'package:yutaa_customer_app/features/bookings/models/booking_model.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';
import 'package:yutaa_customer_app/features/booking/widgets/partner_card.dart';
import 'package:yutaa_customer_app/features/bookings/widgets/booking_status_card.dart';

class BookingStatusScreen extends StatefulWidget {
  final String bookingId;

  const BookingStatusScreen({super.key, required this.bookingId});

  @override
  State<BookingStatusScreen> createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
  @override
  void initState() {
    super.initState();
    BookingsRepository().addListener(_refresh);
  }

  @override
  void dispose() {
    BookingsRepository().removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final booking = BookingsRepository().bookings.firstWhere(
      (b) => b.id == widget.bookingId, 
      orElse: () => throw Exception("Booking not found"),
    );
     final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Booking Status', style: TextStyle(color: theme.colorScheme.onBackground)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // Header info
               Text(
                 'Requests Sent',
                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onBackground),
               ),
               const SizedBox(height: 8),
               Text(
                 'Wait for partners to accept your request. First one to accept will update the status.',
                 style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6)),
               ),
               const SizedBox(height: 24),

               // List of Partners with Status
               // List of Partners with Status
               ...booking.partnerStatuses.map((status) {
                 return BookingStatusCard(partnerStatus: status, booking: booking);
               }),

               // DEBUG TOOL: Simulate Partner Acceptance
               if (booking.status == BookingStatus.waiting)
               Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.grey.withOpacity(0.1),
                    child: Column(
                      children: [
                        const Text("DEBUG: Simulate Partner Activity"),
                        const SizedBox(height: 8),
                         Wrap(
                           spacing: 8,
                           children: booking.partnerStatuses.map((p) {
                             return ElevatedButton(
                               onPressed: () {
                                 BookingsRepository().simulatePartnerApproval(booking.id, p.partner.id);
                               },
                               child: Text("Approve ${p.partner.name.split(' ')[0]}"),
                             );
                           }).toList(),
                         )
                      ],
                    ),
                  ),
               )
            ],
          ),
        ),
      ),
    );
  }

}
