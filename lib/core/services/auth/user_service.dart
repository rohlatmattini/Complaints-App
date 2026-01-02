import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../data/models/Auth/user.dart';

class UserService {
  final storage = const FlutterSecureStorage();

  Future<void> saveUser(UserModel user) async {
    await storage.write(key: "user", value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final data = await storage.read(key: "user");
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  Future<void> clearUser() async {
    await storage.delete(key: "user");
  }
}
