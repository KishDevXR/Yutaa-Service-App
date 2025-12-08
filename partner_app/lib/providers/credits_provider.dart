import 'package:flutter/foundation.dart';

/// Manages partner credit balance for the app.
/// Credits are used to accept enquiries and confirm bookings.
class CreditsProvider extends ChangeNotifier {
  int _credits = 500; // Starting credits for demo

  int get credits => _credits;

  /// Minimum credits required to accept an enquiry
  static const int enquiryAcceptCost = 50;
  
  /// Additional credits for confirmed booking
  static const int bookingConfirmCost = 100;

  /// Check if partner has enough credits
  bool hasEnoughCredits(int amount) => _credits >= amount;

  /// Deduct credits (returns true if successful)
  bool deductCredits(int amount) {
    if (_credits >= amount) {
      _credits -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Add credits (for recharge)
  void addCredits(int amount) {
    _credits += amount;
    notifyListeners();
  }

  /// Reset credits (for testing)
  void resetCredits() {
    _credits = 500;
    notifyListeners();
  }
}

/// Global instance for simple state sharing
/// In production, use Riverpod or Provider package
final creditsProvider = CreditsProvider();
