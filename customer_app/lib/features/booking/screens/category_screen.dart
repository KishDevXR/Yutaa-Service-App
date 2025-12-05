import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yutaa_customer_app/features/booking/data/services_data.dart';
import 'package:yutaa_customer_app/features/booking/models/service_model.dart';
import 'package:yutaa_customer_app/features/booking/widgets/service_card.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final List<String> _filters = ['All', 'Cleaning', 'Beauty & Spa', 'Electrician', 'Painting'];
  String _selectedFilter = 'Electrician';

  @override
  void initState() {
    super.initState();
    // Auto-select the filter matching the category name if it exists in our list
    if (_filters.contains(widget.categoryName)) {
      _selectedFilter = widget.categoryName;
    } else if (widget.categoryName == 'Electrician') {
       _selectedFilter = 'Electrician';
    }
  }

  final Set<String> _cart = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Fetch services from the data repository based on the category parameter
    final services = servicesData[widget.categoryName] ?? [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Area with Search
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.inputDecorationTheme.fillColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? Colors.transparent : Colors.grey.shade300,
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(color: theme.colorScheme.onBackground),
                        decoration: InputDecoration(
                          hintText: 'Search for services',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: isDark ? Colors.white10 : Colors.grey.shade200),
            
            // Services List
            Expanded(
              child: services.isEmpty 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: theme.colorScheme.onBackground.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text(
                        'No services found for\n${widget.categoryName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.5), fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      '${services.length} services found',
                      style: TextStyle(
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...services.map((service) => ServiceCard(
                      service: service,
                      onTap: () {
                        setState(() {
                          if (_cart.contains(service.title)) {
                            _cart.remove(service.title);
                          } else {
                            _cart.add(service.title);
                          }
                        });
                      },
                    )),
                    // Add padding at bottom for Proceed button visibility
                    const SizedBox(height: 80), 
                  ],
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: _cart.isNotEmpty 
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
                  // Find the service model for the first item in the cart
                  try {
                    final selectedServiceTitle = _cart.first;
                    final selectedService = services.firstWhere((s) => s.title == selectedServiceTitle);
                    context.push('/partner-list', extra: selectedService); 
                  } catch (e) {
                    // Handle error locally or ignore
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_cart.length} Service${_cart.length > 1 ? 's' : ''} Added',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const Row(
                        children: [
                          Text('Proceed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      )
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
