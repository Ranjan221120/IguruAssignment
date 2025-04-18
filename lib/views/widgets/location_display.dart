import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/location_controller.dart';

class LocationDisplay extends GetView<LocationController> {
  const LocationDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.isLocationLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
        if (controller.locationErrorMessage.isNotEmpty) {
          return Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  controller.locationErrorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: controller.getCurrentLocation,
                child: const Text('Retry'),
              ),
            ],
          );
        }
        
        final location = controller.currentLocation.value;
        
        if (location == null) {
          return Row(
            children: [
              const Icon(Icons.location_off, color: Colors.grey),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Location unavailable. Please check app permissions.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: controller.getCurrentLocation,
                child: const Text('Try Again'),
              ),
            ],
          );
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red),
                const SizedBox(width: 8),
                const Text(
                  'Current Location:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  onPressed: controller.getCurrentLocation,
                  tooltip: 'Refresh location',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Latitude: ${location.latitude.toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Longitude: ${location.longitude.toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 14),
            ),
            if (location.address != null) ...[
              const SizedBox(height: 8),
              Text(
                'Address: ${location.address}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ],
        );
      }),
    );
  }
} 