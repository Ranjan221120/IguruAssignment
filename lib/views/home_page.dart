import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import 'widgets/location_display.dart';
import 'widgets/user_list_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iguru Assignment'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Location Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LocationDisplay(),
          ),

          // Users List
          Expanded(
            child: Obx(() {
              if (userController.isLoading.value &&
                  userController.users.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (userController.errorMessage.isNotEmpty &&
                  userController.users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userController.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: userController.fetchUsers,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              if (userController.users.isEmpty) {
                return const Center(
                  child: Text('No users found'),
                );
              }

              return RefreshIndicator(
                onRefresh: userController.fetchUsers,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (scrollInfo is ScrollEndNotification &&
                        scrollInfo.metrics.extentAfter == 0 &&
                        !userController.isLoading.value &&
                        userController.hasMorePages.value) {
                      userController.loadMoreUsers();
                      return true;
                    }
                    return false;
                  },
                  child: ListView.builder(
                    itemCount: userController.users.length +
                        (userController.hasMorePages.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the bottom
                      if (index == userController.users.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }

                      final user = userController.users[index];
                      return UserListItem(
                        user: user,
                        controller: userController,
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
