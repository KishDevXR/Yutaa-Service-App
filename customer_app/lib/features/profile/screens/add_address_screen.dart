import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:yutaa_customer_app/core/services/location_service.dart';
import 'package:yutaa_customer_app/core/api/api_client.dart';
import 'package:yutaa_customer_app/theme/app_theme.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final LocationService _locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;
  Map<String, dynamic>? _selectedLocation;

  @override
  void dispose() {
    _searchController.dispose();
    _labelController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Detect current location
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationData position = await _locationService.getCurrentPosition();
      
      if (position.latitude == null || position.longitude == null) {
        throw Exception('Failed to get location coordinates');
      }

      final addressData = await _locationService.getAddressFromCoordinates(
        position.latitude!,
        position.longitude!,
      );
      _fillAddressForm(addressData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Search for updated query
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() => _searchResults = []);
        return;
      }

      try {
        final results = await _locationService.searchLocation(query);
        setState(() => _searchResults = results);
      } catch (e) {
        print('Search error: $e');
      }
    });
  }

  // Fill form with address data
  void _fillAddressForm(Map<String, dynamic> data) {
    setState(() {
      _selectedLocation = data;
      _searchResults = []; // Clear search results
      _searchController.clear(); // Clear search bar

      final address = data['address'] ?? {};
      String street = address['road'] ?? address['suburb'] ?? address['neighbourhood'] ?? '';
      String city = address['city'] ?? address['town'] ?? address['village'] ?? address['county'] ?? '';
      String zip = address['postcode'] ?? '';
      
      // Construct a readable address string
      String fullAddress = data['display_name'] ?? '';
      
      _addressController.text = fullAddress;
      _cityController.text = city;
      _zipController.text = zip;
    });
  }

  void _onSelectSearchResult(Map<String, dynamic> result) {
    _fillAddressForm(result);
  }

  Future<void> _saveAddress() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter an address')),
      );
      return;
    }
    
    // Default coordinates if not selected from map/location (fallback)
    double lat = 0.0;
    double lng = 0.0;
    
    if (_selectedLocation != null) {
      lat = double.tryParse(_selectedLocation!['lat'] ?? '0') ?? 0.0;
      lng = double.tryParse(_selectedLocation!['lon'] ?? '0') ?? 0.0;
    }

    setState(() => _isLoading = true);

    try {
      final apiClient = ApiClient();
      final response = await apiClient.addAddress(
        label: _labelController.text.trim().isEmpty ? 'Home' : _labelController.text.trim(),
        fullAddress: _addressController.text.trim(),
        city: _cityController.text.trim(),
        pincode: _zipController.text.trim(),
        lat: lat,
        lng: lng,
      );

      if (response.statusCode == 200 && response.data['success']) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address Saved Successfully!')),
          );
          context.go('/home');
        }
      } else {
        throw Exception(response.data['message'] ?? 'Failed to save address');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving address: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      body: Column(
        children: [
          // Search & Detect Section
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.appBarTheme.backgroundColor,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search for area, street name...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _isLoading 
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Use Current Location Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _getCurrentLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Use my current location'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Stack(
              children: [
                // Address Form
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Address Details',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      
                      // Label (Home, Work, etc)
                      TextField(
                        controller: _labelController,
                        decoration: const InputDecoration(
                          labelText: 'Label (e.g., Home, Work)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Full Address
                      TextField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Full Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _cityController,
                              decoration: const InputDecoration(
                                labelText: 'City',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _zipController,
                              decoration: const InputDecoration(
                                labelText: 'Zip Code',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save Address',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Search Results Overlay
                if (_searchResults.isNotEmpty)
                  Container(
                    color: theme.scaffoldBackgroundColor,
                    child: ListView.separated(
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: Text(result['display_name'] ?? ''),
                          subtitle: Text(result['type'] ?? ''),
                          onTap: () => _onSelectSearchResult(result),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
