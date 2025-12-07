import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yutaa_partner_app/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yutaa Partner',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Your work, your way',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Online Toggle Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: _isOnline ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isOnline ? Colors.green.withOpacity(0.3) : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isOnline ? Colors.green.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.circle, color: _isOnline ? Colors.green : Colors.grey.shade400, size: 12),
                          const SizedBox(width: 8),
                          Text(
                            _isOnline ? "You are Online" : "You are Offline",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isOnline ? 
                              const Color(0xFF2E7D32) 
                              : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isOnline ? "Ready to receive job requests" : "Not receiving job requests",
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isOnline,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF4CAF50), 
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade400, // Match screenshot grey
                    trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                    onChanged: (val) {
                      setState(() {
                        _isOnline = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Today's Summary
            Text(
              "Today's Summary",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      icon: Icons.attach_money,
                      color: Colors.amber,
                      label: "Earnings",
                      value: "\$120.50",
                      bgColor: const Color(0xFFFFF8E1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryItem(
                      icon: Icons.check_circle_outline,
                      color: AppTheme.primaryPurple,
                      label: "Jobs",
                      value: "3",
                      bgColor: const Color(0xFFF3E5F5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Conditional Content (Online Jobs vs Offline Placeholder)
            if (_isOnline) ...[
              // Online: Job Requests
              Row(
                children: [
                  const Icon(Icons.circle, color: Color(0xFF4CAF50), size: 10),
                  const SizedBox(width: 8),
                  Text(
                    "New Job Request",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Job Request Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryPurple.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer Info
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                                child: Icon(Icons.person_outline, color: Colors.grey.shade600),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Customer", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                                  Text("Alice M.", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Service Info
                          Text("Service Requested", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text("AC Repair (Deep Clean)", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),

                          // Location Info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined, color: AppTheme.primaryPurple, size: 20),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("10 Avenue of the Arts", style: GoogleFonts.poppins(fontSize: 14)),
                                  Text("2.5 km away", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Price
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFDE7), // Light yellow
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Service Price", style: GoogleFonts.poppins(color: Colors.black87)),
                                Text("\$ 45.00", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber.shade800)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16)),
                                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                              ),
                              child: Center(
                                child: Text(
                                  "Reject",
                                  style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50), // Green
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
                              ),
                              child: Center(
                                child: Text(
                                  "Accept",
                                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Offline View
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.power_settings_new, color: Colors.grey.shade600, size: 40),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "You're Offline",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Toggle online to start receiving job requests",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({required IconData icon, required Color color, required String label, required String value, required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color == Colors.amber ? Colors.amber.shade700 : AppTheme.primaryPurple,
            ),
          ),
        ],
      ),
    );
  }
}
