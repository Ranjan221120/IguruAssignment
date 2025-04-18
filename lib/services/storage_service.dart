import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/user_model.dart';

class StorageService {
  static const String userBoxName = 'usersBox';

  Future<void> initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<User>(userBoxName);
  }

  Future<void> saveUserImage(int userId, String imagePath) async {
    final box = Hive.box<User>(userBoxName);

    // Get the user if exists
    final user = box.get(userId);

    if (user != null) {
      // Update existing user
      user.localImagePath = imagePath;
      await box.put(userId, user);
    }
  }

  Future<String?> getUserImage(int userId) async {
    final box = Hive.box<User>(userBoxName);
    final user = box.get(userId);
    return user?.localImagePath;
  }

  Future<void> saveUsers(List<User> users) async {
    final box = Hive.box<User>(userBoxName);

    // Create a map with user.id as key and user as value
    final Map<int, User> userMap = {};
    for (var user in users) {
      // Check if user already exists to preserve local image path
      final existingUser = box.get(user.id);
      if (existingUser != null && existingUser.localImagePath != null) {
        user.localImagePath = existingUser.localImagePath;
      }
      userMap[user.id] = user;
    }

    await box.putAll(userMap);
  }

  Future<List<User>> getUsers() async {
    final box = Hive.box<User>(userBoxName);
    return box.values.toList();
  }
}
