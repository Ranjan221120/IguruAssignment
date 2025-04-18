import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/image_picker_service.dart';

class UserController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  final ImagePickerService _imagePickerService = ImagePickerService();
  
  RxList<User> users = <User>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasMorePages = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }
  
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      currentPage.value = 1;
      
      // Reset users list when fetching first page
      users.clear();
      
      // Fetch users from API
      final remoteUsers = await _apiService.getUsers(page: currentPage.value);
      
      // Save fetched users to local storage
      await _storageService.saveUsers(remoteUsers);
      
      // Update users list
      users.value = await _storageService.getUsers();
      
      // Check if there are more pages
      hasMorePages.value = remoteUsers.isNotEmpty;
      
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadMoreUsers() async {
    if (isLoading.value || !hasMorePages.value) return;
    
    try {
      isLoading.value = true;
      currentPage.value++;
      
      // Fetch next page of users
      final moreUsers = await _apiService.getUsers(page: currentPage.value);
      
      if (moreUsers.isEmpty) {
        hasMorePages.value = false;
        return;
      }
      
      // Save fetched users to local storage and append to existing users
      await _storageService.saveUsers([...users, ...moreUsers]);
      
      // Update users list
      users.value = await _storageService.getUsers();
      
    } catch (e) {
      errorMessage.value = e.toString();
      currentPage.value--; // Revert page increment on error
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> uploadUserImage(int userId, {required bool fromCamera}) async {
    try {
      final imagePath = await _imagePickerService.pickImage(fromCamera: fromCamera);
      
      if (imagePath != null) {
        // Save image path to local storage
        await _storageService.saveUserImage(userId, imagePath);
        
        // Refresh user list
        users.value = await _storageService.getUsers();
      }
    } catch (e) {
      errorMessage.value = 'Failed to upload image: $e';
    }
  }
} 