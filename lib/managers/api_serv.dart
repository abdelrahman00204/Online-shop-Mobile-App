import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_project/managers/auth_manage.dart';

class ApiService {
  static final String _baseUrl = dotenv.get('API_URL');

  static Future<Map<String, dynamic>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/customer/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    print('Login status: ${response.statusCode}');
    print('Login body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data;
    } else if (response.statusCode == 404) {
      throw 'user_not_found';
    } else if (response.statusCode == 401) {
      throw 'wrong_password';
    } else {
      throw 'error';
    }
  }

  static Future<void> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String favBranch,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/customer/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        "phoneNumber": phone,
        "preferredBranchId": favBranch,
      }),
    );
    if (response.statusCode == 400) {
      print('Registration failed: ${response.statusCode} - ${response.body}');
      throw 'password_requirements_failed';
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Registration failed: ${response.statusCode} - ${response.body}');
      throw 'registration_failed';
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogleProvider(
    String providerToken,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/customer/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'IdToken': providerToken}),
    );
    print('Google login raw response: ${response.body}'); // ADD THIS LINE
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print(
        'Social authentication failed: ${response.statusCode} - ${response.body}',
      );
      throw 'social_auth_failed';
    }
  }

  static Future<Map<String, dynamic>> loginWithFacebookProvider(
    String providerToken,
  ) async {
    print('Sending Facebook token: $providerToken'); // ADD THIS LINE
    final response = await http.post(
      Uri.parse('$_baseUrl/customer/auth/facebook'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'AccessToken': providerToken}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print(
        'Social authentication failed: ${response.statusCode} - ${response.body}',
      );
      throw 'social_auth_failed';
    }
  }

  static Future<Map<String, dynamic>> saveGoogleProfile({
    required String token,
    required int preferredBranchId,
    required String phone,
  }) async {
    for (int i = 0; i < token.length; i += 100) {
      final end = (i + 100 < token.length) ? i + 100 : token.length;
      print('TOKEN PART: ${token.substring(i, end)}');
    }

    final body = jsonEncode({
      'IdToken': token,
      'PreferredBranchId': preferredBranchId,
      'PhoneNumber': phone,
    });
    print('BODY LENGTH: ${body.length}');
    print('BODY TAIL: ${body.substring(body.length - 80)}'); // last 80 chars

    final response = await http.post(
      Uri.parse('$_baseUrl/customer/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print('SAVE PROFILE STATUS: ${response.statusCode}');
    print('SAVE PROFILE BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw 'profile_save_failed';
    }
  }

  static Future<Map<String, dynamic>> saveFacebookProfile({
    required String token,
    required String phone,
    required int preferredBranchId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/customer/auth/facebook'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // send JWT in header
      },

      body: jsonEncode({
        'AccessToken': token,
        'PhoneNumber': phone,
        'PreferredBranchId': preferredBranchId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw 'profile_save_failed';
    }
  }

  static Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('send email failed: ${response.statusCode} - ${response.body}');
      throw 'password_reset_failed';
    }
  }

  static Future<void> codeVerfication(String code, String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'code': code, 'email': email}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print(
        'Code verification failed: ${response.statusCode} - ${response.body}',
      );
      throw 'Wrong code';
    }
  }

  static Future<void> sendNewPassword(
    String email,
    String newPassword,
    String code,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/complete-reset-password?code=$code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'newPassword': newPassword}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Password reset failed: ${response.statusCode} - ${response.body}');
      throw 'somthing went wrong , please try again ';
    }
  }

  static Future<void> changePassword(
    String token,
    String currentPassword,
    String newPassword,
  ) async {
    final response = await http.put(
      Uri.parse('$_baseUrl//customer/profile/change-password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode == 400) {
      print('Password reset failed: ${response.statusCode} - ${response.body}');
      throw 'google';
    } else if (response.statusCode != 200 && response.statusCode != 201) {
      print('Password reset failed: ${response.statusCode} - ${response.body}');
      throw 'somthing went wrong , please try again ';
    }
  }

  static Future<void> updateUserProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String phone,
    required int? preferredBranchId,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/customer/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phone,
        'preferredBranchId': preferredBranchId,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Update profile failed: ${response.statusCode} - ${response.body}');
      throw 'somthing went wrong , please try again ';
    } else {
      await getProfile(token: token);
      print(
        'Update profile succeeded: ${response.statusCode} - ${response.body}',
      );
    }
  }

  static Future<Map<String, dynamic>> getProfile({
    required String token,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/customer/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Update profile failed: ${response.statusCode} - ${response.body}');
      throw 'somthing went wrong , please try again ';
    } else {
      AuthManage.instance.login(
        jsonDecode(response.body)['email'],
        AuthManage.instance.userToken ?? '',
        jsonDecode(response.body)['firstName'],
        jsonDecode(response.body)['lastName'],
        jsonDecode(response.body)['preferredBranchId'] as int?,
        jsonDecode(response.body)['phoneNumber'] as String,
      );
      return jsonDecode(response.body);
    }
  }
}
