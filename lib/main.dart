import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/location_controller.dart';
import 'controllers/user_controller.dart';
import 'services/storage_service.dart';
import 'views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final storageService = StorageService();
  await storageService.initHive();

  // Initialize app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'User Directory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    Get.put(LocationController());
    Get.put(UserController());

    return const HomePage();
  }
}
