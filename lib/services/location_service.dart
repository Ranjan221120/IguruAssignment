import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location_model.dart';

class LocationService {
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<LocationModel?> getCurrentLocation() async {
    try {
      // Check permissions
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        return null;
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      final addresses = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (addresses.isNotEmpty) {
        final place = addresses.first;
        final address = '${place.street}, ${place.locality}, ${place.country}';
        
        return LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        );
      } else {
        return LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      rethrow;
    }
  }
} 