import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManage extends ChangeNotifier {
  // Singleton pattern — one instance across the whole app
  static final AuthManage instance = AuthManage._internal();
  AuthManage._internal();

  final _storage = const FlutterSecureStorage();

  // Keys used to read/write from secure storage
  static const _keyEmail = 'email';
  static const _keyToken = 'token';
  static const _keyFirstName = 'firstName';
  static const _keyLastName = 'lastName';
  static const _keyPhone = 'phone';
  static const _keyFavBranch = 'favBranch';

  // In-memory state
  bool isLoggedIn = false;
  String? userEmail;
  String? userToken;
  String? userFirstName;
  String? userLastName;
  String? userPhone;
  int? userFavBranch;

  Future<void> tryAutoLogin() async {
    final storedToken = await _storage.read(key: _keyToken);
    final storedEmail = await _storage.read(key: _keyEmail);
    final storedFirstName = await _storage.read(key: _keyFirstName);
    final storedLastName = await _storage.read(key: _keyLastName);
    final storedPhone = await _storage.read(key: _keyPhone);
    final storedFavBranch = await _storage.read(key: _keyFavBranch);

    if (storedToken != null && storedEmail != null) {
      userToken = storedToken;
      userEmail = storedEmail;
      userFirstName = storedFirstName;
      userLastName = storedLastName;
      userPhone = storedPhone;
      userFavBranch = storedFavBranch != null
          ? int.tryParse(storedFavBranch)
          : null;
      isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> login(
    String email,
    String newToken,
    String firstName,
    String lastName,
    int? favBranch,
    String phone,
  ) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyToken, value: newToken);
    await _storage.write(key: _keyFirstName, value: firstName);
    await _storage.write(key: _keyLastName, value: lastName);
    await _storage.write(key: _keyFavBranch, value: favBranch?.toString());
    await _storage.write(key: _keyPhone, value: phone);

    userEmail = email;
    userToken = newToken;
    userFirstName = firstName;
    userLastName = lastName;
    userFavBranch = favBranch;
    userPhone = phone;
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyFirstName);
    await _storage.delete(key: _keyLastName);
    await _storage.delete(key: _keyPhone);
    await _storage.delete(key: _keyFavBranch);
    userEmail = null;
    userToken = null;
    userFirstName = null;
    userLastName = null;
    userPhone = null;
    userFavBranch = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
