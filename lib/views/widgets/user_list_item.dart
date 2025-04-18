import 'dart:io';

import 'package:flutter/material.dart';

import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final UserController controller;

  const UserListItem({
    Key? key,
    required this.user,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // User Avatar or Local Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: user.localImagePath != null
                        ? Image.file(
                            File(user.localImagePath!),
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            user.avatar,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.grey,
                              );
                            },
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 15,
                      ),
                      onSelected: (value) {
                        if (value == 'camera') {
                          controller.uploadUserImage(user.id, fromCamera: true);
                        } else if (value == 'gallery') {
                          controller.uploadUserImage(user.id,
                              fromCamera: false);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'camera',
                          child: Row(
                            children: [
                              Icon(Icons.camera_alt),
                              SizedBox(width: 8),
                              Text('Camera'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'gallery',
                          child: Row(
                            children: [
                              Icon(Icons.photo_library),
                              SizedBox(width: 8),
                              Text('Gallery'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // User Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
