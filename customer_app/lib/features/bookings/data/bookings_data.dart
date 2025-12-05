import 'package:flutter/foundation.dart';
import 'package:yutaa_customer_app/features/bookings/models/booking_model.dart';
import 'package:yutaa_customer_app/features/booking/models/partner_model.dart';
import 'package:yutaa_customer_app/features/booking/models/service_model.dart';

// Simple Mock Repository (in-memory)
class BookingsRepository extends ChangeNotifier {
  static final BookingsRepository _instance = BookingsRepository._internal();
  factory BookingsRepository() => _instance;
  BookingsRepository._internal();

  final List<BookingModel> _bookings = [];

  List<BookingModel> get bookings => List.unmodifiable(_bookings);

  void addBooking({
    required ServiceModel service,
    required List<PartnerModel> partners,
    required DateTime date,
    required String timeSlot,
    required String address,
  }) {
    final newBooking = BookingModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      service: service,
      date: date,
      timeSlot: timeSlot,
      address: address,
      partnerStatuses: partners.map((p) => PartnerBookingStatus(partner: p)).toList(),
      status: BookingStatus.waiting,
    );
    _bookings.insert(0, newBooking); // Add to top
    notifyListeners();
  }

  // Simulate Partner Approving Request
  void simulatePartnerApproval(String bookingId, String partnerId) {
    try {
      final booking = _bookings.firstWhere((b) => b.id == bookingId);
      
      // Update the specific partner to Approved
      final partnerStatus = booking.partnerStatuses.firstWhere((p) => p.partner.id == partnerId);
      partnerStatus.status = PartnerRequestStatus.approved;
      
      // Cancel others? Logic: "who accept first is concept".
      // So if one accepts, others are effectively cancelled for this specific request.
      for (var p in booking.partnerStatuses) {
        if (p.partner.id != partnerId) {
          p.status = PartnerRequestStatus.cancelled;
        }
      }
      
      booking.status = BookingStatus.approved; // Overall status ready for user confirmation
      notifyListeners();
    } catch (e) {
      debugPrint("Error updating booking: $e");
    }
  }

  // User Accepts the Logic
  void userConfirmPartner(String bookingId, String partnerId) {
     try {
       final booking = _bookings.firstWhere((b) => b.id == bookingId);
       booking.status = BookingStatus.in_progress;
       notifyListeners();
     } catch (e) {
       debugPrint("Error confirming booking: $e");
     }
  }
}
