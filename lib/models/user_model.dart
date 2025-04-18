import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String firstName;
  
  @HiveField(3)
  final String lastName;
  
  @HiveField(4)
  final String avatar;
  
  @HiveField(5)
  String? localImagePath;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    this.localImagePath,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
      'local_image_path': localImagePath,
    };
  }

  String get fullName => '$firstName $lastName';
} 