import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yutaa_partner_app/theme/app_theme.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Confirmed', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bookings',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search bookings...',
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(
                              filter,
                              style: GoogleFonts.poppins(
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppTheme.primaryPurple,
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected ? Colors.transparent : Colors.grey.shade300,
                              ),
                            ),
                            showCheckmark: false,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            // List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSectionHeader("Today"),
                  _buildBookingCard(
                    title: "AC Repair & Service",
                    id: "#000001",
                    time: "2:00 PM - 3:00 PM",
                    location: "Koramangala, Bangalore",
                    customer: "Rajesh Kumar",
                    price: "₹899",
                    status: "Confirmed",
                  ),
                  _buildBookingCard(
                    title: "Plumbing",
                    id: "#000002",
                    time: "4:30 PM - 5:30 PM",
                    location: "HSR Layout, Bangalore",
                    customer: "Priya Sharma",
                    price: "₹599",
                    status: "Confirmed",
                  ),

                  _buildSectionHeader("Tomorrow"),
                  _buildBookingCard(
                    title: "Carpentry",
                    id: "#000004",
                    time: "3:00 PM - 4:30 PM",
                    location: "Indiranagar, Bangalore",
                    customer: "Neha Singh",
                    price: "₹1200",
                    status: "Pending",
                  ),

                   _buildSectionHeader("Yesterday"),
                  _buildBookingCard(
                    title: "Electrical Repair",
                    id: "#000003",
                    time: "11:00 AM - 12:00 PM",
                    location: "Whitefield, Bangalore",
                    customer: "Amit Patel",
                    price: "₹750",
                    status: "Completed",
                  ),
                  const SizedBox(height: 80), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
      ),
    );
  }

  Widget _buildBookingCard({
    required String title,
    required String id,
    required String time,
    required String location,
    required String customer,
    required String price,
    required String status,
  }) {
    Color statusColor;
    Color statusBgColor;

    switch (status) {
      case 'Confirmed':
        statusColor = Colors.green.shade700;
        statusBgColor = Colors.green.shade50;
        break;
      case 'Completed':
        statusColor = Colors.blue.shade700;
        statusBgColor = Colors.blue.shade50;
        break;
      case 'Pending':
        statusColor = Colors.amber.shade800; // Using amber for mockup yellow
        statusBgColor = Colors.amber.shade50;
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.shade100;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: GoogleFonts.poppins(color: statusColor, fontSize: 11, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("ID: $id", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
          
          const SizedBox(height: 12),
          // Info Rows
          _buildInfoRow(Icons.access_time, time),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on_outlined, location),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.phone_outlined, customer),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Colors.grey.shade100, height: 1),
          ),

          // Footer Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
              if (status == 'Confirmed')
                Row(
                  children: [
                    _buildIconButton(Icons.phone_outlined, Colors.purple.shade50, Colors.purple),
                    const SizedBox(width: 12),
                    _buildIconButton(Icons.near_me_outlined, Colors.purple.shade50, Colors.purple),
                  ],
                ),
               if (status == 'Completed')
                ElevatedButton(
                  onPressed: (){}, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(0, 36)
                  ),
                  child: Text("View Details", style: GoogleFonts.poppins(fontSize: 12)),
                ),
               if (status == 'Pending')
                Row(
                  children: [
                    TextButton(
                      onPressed: (){},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                         minimumSize: const Size(0, 36)
                      ), 
                      child: Text("Reject", style: GoogleFonts.poppins(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                         minimumSize: const Size(0, 36)
                      ), 
                      child: Text("Accept", style: GoogleFonts.poppins(fontSize: 12)),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 13)),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
