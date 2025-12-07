import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yutaa_partner_app/features/bookings/screens/bookings_screen.dart';
import 'package:yutaa_partner_app/features/home/screens/home_screen.dart';
import 'package:yutaa_partner_app/theme/app_theme.dart';

class PartnerMainWrapper extends StatefulWidget {
  const PartnerMainWrapper({super.key});

  @override
  State<PartnerMainWrapper> createState() => _PartnerMainWrapperState();
}

class _PartnerMainWrapperState extends State<PartnerMainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingsScreen(),
    const Center(child: Text("Earnings Screen")), // Placeholder
    const Center(child: Text("Profile Screen")), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          indicatorColor: AppTheme.primaryPurple.withOpacity(0.1),
          height: 65,
          destinations: [
            _buildNavItem(Icons.home_outlined, Icons.home, "Home"),
            _buildNavItem(Icons.work_outline, Icons.work, "Jobs"),
            _buildNavItem(Icons.attach_money, Icons.attach_money, "Earnings"),
            _buildNavItem(Icons.person_outline, Icons.person, "Profile"),
          ],
        ),
      ),
    );
  }

  NavigationDestination _buildNavItem(IconData icon, IconData selectedIcon, String label) {
    return NavigationDestination(
      icon: Icon(icon, color: Colors.grey.shade600),
      selectedIcon: Icon(selectedIcon, color: AppTheme.primaryPurple),
      label: label,
    );
  }
}
