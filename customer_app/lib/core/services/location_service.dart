import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:location/location.dart';

class LocationService {
  final Dio _dio = Dio();
  final String _nominatimUrl = 'https://nominatim.openstreetmap.org';
  final Location _location = Location();

  // Get current position
  Future<LocationData> getCurrentPosition() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
    }

    // Check permissions
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permissions are denied');
      }
    }

    return await _location.getLocation();
  }

  // Reverse geocoding: Coords -> Address
  Future<Map<String, dynamic>> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final response = await _dio.get(
        '$_nominatimUrl/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'format': 'json',
          'addressdetails': 1,
        },
        options: Options(
          headers: {
            'User-Agent': 'YutaaServiceApp/1.0', // Required by OSM
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get address');
      }
    } catch (e) {
      throw Exception('Error getting address: $e');
    }
  }

  // Search location: Query -> List of addresses
  Future<List<dynamic>> searchLocation(String query) async {
    try {
      final response = await _dio.get(
        '$_nominatimUrl/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'addressdetails': 1,
          'limit': 5,
        },
        options: Options(
          headers: {
            'User-Agent': 'YutaaServiceApp/1.0',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to search location');
      }
    } catch (e) {
      throw Exception('Error searching location: $e');
    }
  }
}
