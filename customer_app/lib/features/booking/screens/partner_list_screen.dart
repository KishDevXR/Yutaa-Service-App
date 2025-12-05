import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yutaa_customer_app/features/booking/data/partners_data.dart';
import 'package:yutaa_customer_app/features/booking/models/partner_model.dart';
import 'package:yutaa_customer_app/features/booking/widgets/partner_card.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';

import 'package:yutaa_customer_app/features/booking/models/service_model.dart';
// ... imports

class PartnerListScreen extends StatefulWidget {
  final ServiceModel service;

  const PartnerListScreen({super.key, required this.service});

  @override
  State<PartnerListScreen> createState() => _PartnerListScreenState();
}

class _PartnerListScreenState extends State<PartnerListScreen> {
  final List<String> _filters = ['Recommended', 'Highest Rated', 'Nearest', 'Price: Low to High'];
  String _selectedFilter = 'Recommended';
  final Set<String> _selectedPartnerIds = {};

  void _togglePartnerSelection(String partnerId) {
    setState(() {
      if (_selectedPartnerIds.contains(partnerId)) {
        _selectedPartnerIds.remove(partnerId);
      } else {
        if (_selectedPartnerIds.length < 3) {
          _selectedPartnerIds.add(partnerId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can select up to 3 professionals only')),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Fetch partners based on service name
    final partners = partnersData[widget.service.title] ?? partnersData['Electrician'] ?? [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // ... (AppBar content remains same)
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
          onPressed: () => context.pop(),
        ),
        title: const Text('Back'), 
        titleSpacing: 0,
        titleTextStyle: TextStyle(color: theme.colorScheme.onBackground, fontSize: 16),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ... (Header and Filters remain same)
            // Service Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              color: theme.scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${partners.length} professionals available • ${widget.service.price}',
                    style: TextStyle(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Service Info Card (Top Summary)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.electrical_services, color: Colors.grey), // Placeholder
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Installation and repair of electrical switches and sockets",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 12, color: theme.colorScheme.onBackground),
                                  Text(' 30 min  ', style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 12)),
                                  const Icon(Icons.star, size: 12, color: Colors.amber),
                                  Text(' 4.6', style: TextStyle(color: theme.colorScheme.onBackground, fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),

            // Horizontal Filters
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryPurple
                            : (isDark ? const Color(0xFF252634) : Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),
            Divider(color: isDark ? Colors.white10 : Colors.grey.shade200, thickness: 4), // Separator
            const SizedBox(height: 16),

            // Partner List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: partners.length,
                itemBuilder: (context, index) {
                  final partner = partners[index];
                  final isSelected = _selectedPartnerIds.contains(partner.id);
                  return PartnerCard(
                    partner: partner,
                    isSelected: isSelected,
                    onSelect: () => _togglePartnerSelection(partner.id),
                  );
                },
              ),
            ),
            
             // Bottom Padding for FAB
            if (_selectedPartnerIds.isNotEmpty) const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: _selectedPartnerIds.isNotEmpty 
        ? Container(
            width: MediaQuery.of(context).size.width - 32,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.primaryPurple, Color(0xFFA960EE)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                 BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                   // Navigate to Booking Details with selected partners
                   // Find the partner models
                   final selectedPartners = partners.where((p) => _selectedPartnerIds.contains(p.id)).toList();
                   context.push(
                     '/booking-details', 
                     extra: {
                       'service': widget.service,
                       'partners': selectedPartners
                     }
                   );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedPartnerIds.length} Professional${_selectedPartnerIds.length > 1 ? 's' : ''} Selected',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Text('Request Booking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          )
        : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
