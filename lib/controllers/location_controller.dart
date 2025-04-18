import 'package:get/get.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();
  
  Rx<LocationModel?> currentLocation = Rx<LocationModel?>(null);
  RxBool isLocationLoading = false.obs;
  RxString locationErrorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }
  
  Future<void> getCurrentLocation() async {
    try {
      isLocationLoading.value = true;
      locationErrorMessage.value = '';
      
      final location = await _locationService.getCurrentLocation();
      currentLocation.value = location;
      
      if (location == null) {
        locationErrorMessage.value = 'Unable to get location. Please check permissions.';
      }
    } catch (e) {
      locationErrorMessage.value = e.toString();
    } finally {
      isLocationLoading.value = false;
    }
  }
} 