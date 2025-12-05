import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yutaa_customer_app/features/booking/models/partner_model.dart';
import 'package:yutaa_customer_app/features/booking/models/service_model.dart';
import 'package:yutaa_customer_app/features/bookings/data/bookings_data.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';
import 'package:intl/intl.dart';

class BookingDetailsScreen extends StatefulWidget {
  final ServiceModel service;
  final List<PartnerModel> partners;

  const BookingDetailsScreen({
    super.key,
    required this.service,
    required this.partners,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTimeSlot = '10:00 AM';
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  final List<String> _timeSlots = [
    '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM',
    '04:00 PM', '05:00 PM', '06:00 PM', '07:00 PM',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Booking Details', style: TextStyle(color: theme.colorScheme.onBackground)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Summary
                    _buildSectionTitle(theme, 'Service info'),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.service.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onBackground)),
                          const SizedBox(height: 8),
                          Text('Selected Professionals:', style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.6), fontSize: 12)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: widget.partners.map((p) => Chip(
                              label: Text(p.name, style: const TextStyle(fontSize: 12)),
                              avatar: CircleAvatar(child: Text(p.name[0])),
                              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                            )).toList(),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Date Selection
                    _buildSectionTitle(theme, 'Select Date'),
                    Container(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 14,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final date = DateTime.now().add(Duration(days: index + 1));
                          final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedDate = date),
                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primaryPurple : theme.cardColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? AppTheme.primaryPurple : (isDark ? Colors.white10 : Colors.grey.shade300)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('EEE').format(date),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : theme.colorScheme.onBackground.withOpacity(0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    date.day.toString(),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : theme.colorScheme.onBackground,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Time Selection
                    _buildSectionTitle(theme, 'Select Time'),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _timeSlots.map((time) {
                        final isSelected = time == _selectedTimeSlot;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTimeSlot = time),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primaryPurple : theme.cardColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isSelected ? AppTheme.primaryPurple : (isDark ? Colors.white10 : Colors.grey.shade300)),
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                color: isSelected ? Colors.white : theme.colorScheme.onBackground,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Address
                    _buildSectionTitle(theme, 'Service Address'),
                    TextField(
                      controller: _addressController,
                      style: TextStyle(color: theme.colorScheme.onBackground),
                      decoration: InputDecoration(
                        hintText: 'Enter complete address',
                         hintStyle: TextStyle(color: theme.hintColor),
                        filled: true,
                        fillColor: theme.inputDecorationTheme.fillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.grey),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),

                     // Instructions
                    _buildSectionTitle(theme, 'Special Instructions (Optional)'),
                    TextField(
                      controller: _instructionController,
                      style: TextStyle(color: theme.colorScheme.onBackground),
                      decoration: InputDecoration(
                        hintText: 'Any specific instructions...',
                        hintStyle: TextStyle(color: theme.hintColor),
                        filled: true,
                         fillColor: theme.inputDecorationTheme.fillColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // Bottom padding
                  ],
                ),
              ),
            ),
             Padding(
               padding: const EdgeInsets.all(16.0),
               child: ElevatedButton(
                  onPressed: () {
                    // Create Booking
                    BookingsRepository().addBooking(
                      service: widget.service,
                      partners: widget.partners,
                      date: _selectedDate,
                      timeSlot: _selectedTimeSlot,
                      address: _addressController.text.isEmpty ? "123 Main St, City" : _addressController.text, // Default for testing
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Booking Request Sent!')),
                    );
                    context.go('/bookings'); // Navigate to Bookings Tab
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Book Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onBackground,
        ),
      ),
    );
  }
}
