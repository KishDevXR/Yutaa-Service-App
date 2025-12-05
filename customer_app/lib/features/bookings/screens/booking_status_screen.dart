import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yutaa_customer_app/features/bookings/data/bookings_data.dart';
import 'package:yutaa_customer_app/features/bookings/models/booking_model.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';
import 'package:yutaa_customer_app/features/booking/widgets/partner_card.dart';

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
               ...booking.partnerStatuses.map((status) {
                 return Column(
                   children: [
                     Stack(
                       children: [
                         // Disable card interaction mostly, just show info
                         IgnorePointer(
                           ignoring: true,
                           child: PartnerCard(partner: status.partner),
                         ),
                         // Overlay Status
                         Positioned.fill(
                           child: Container(
                             decoration: BoxDecoration(
                               color: _getOverlayColor(status.status),
                               borderRadius: BorderRadius.circular(16),
                             ),
                             child: Center(
                               child: _buildStatusAction(context, booking, status),
                             ),
                           ),
                         ),
                       ],
                     ),
                     const SizedBox(height: 16),
                   ],
                 );
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

  Color _getOverlayColor(PartnerRequestStatus status) {
    if (status == PartnerRequestStatus.waiting) return Colors.transparent;
    if (status == PartnerRequestStatus.cancelled) return Colors.black.withOpacity(0.5); // Dimmed
    if (status == PartnerRequestStatus.approved) return Colors.green.withOpacity(0.1); 
    return Colors.transparent;
  }

  Widget _buildStatusAction(BuildContext context, BookingModel booking, PartnerBookingStatus status) {
     if (status.status == PartnerRequestStatus.waiting) {
       return Container(
         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
         decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
         child: const Text('Waiting...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
       );
     }
     if (status.status == PartnerRequestStatus.cancelled) {
        return const Text('Cancelled', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18));
     }
     if (status.status == PartnerRequestStatus.approved) {
        if (booking.status == BookingStatus.approved) {
           // User needs to confirm
           return Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text('Accepted Request!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
               const SizedBox(height: 8),
               ElevatedButton(
                 onPressed: () {
                    BookingsRepository().userConfirmPartner(booking.id, status.partner.id);
                 }, 
                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                 child: const Text('Confirm & Pay'),
               )
             ],
           );
        } else if (booking.status == BookingStatus.in_progress) {
             return const Text('In Progress', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20));
        }
     }
     return const SizedBox();
  }
}
