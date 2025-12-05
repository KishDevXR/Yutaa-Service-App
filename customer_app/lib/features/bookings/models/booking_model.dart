import 'package:yutaa_customer_app/features/booking/models/partner_model.dart';
import 'package:yutaa_customer_app/features/booking/models/service_model.dart';

enum BookingStatus { waiting, approved, in_progress, completed, cancelled }
enum PartnerRequestStatus { waiting, approved, rejected, cancelled }

class PartnerBookingStatus {
  final PartnerModel partner;
  PartnerRequestStatus status;

  PartnerBookingStatus({required this.partner, this.status = PartnerRequestStatus.waiting});
}

class BookingModel {
  final String id;
  final ServiceModel service;
  final DateTime date;
  final String timeSlot;
  final String address;
  final List<PartnerBookingStatus> partnerStatuses;
  BookingStatus status;

  BookingModel({
    required this.id,
    required this.service,
    required this.date,
    required this.timeSlot,
    required this.address,
    required this.partnerStatuses,
    this.status = BookingStatus.waiting,
  });
}
