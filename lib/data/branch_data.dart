import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

List<BranchData> branches = [];

class BranchData {
  int id;
  String name;
  String adress;
  String city;
  String phoneNumber;
  DateTime? openingTime;
  DateTime? closingTime;

  BranchData({
    required this.id,
    required this.name,
    required this.adress,
    required this.city,
    required this.phoneNumber,
    required this.openingTime,
    required this.closingTime,
  });

  factory BranchData.fromJson(Map<String, dynamic> json) {
    return BranchData(
      id: json['id'],
      name: json['name'],
      adress: json['address'] ?? '',
      city: json['city'] ?? '',
      phoneNumber: json['phoneNumber'],
      openingTime: _parseTime(json['openingTime']),
      closingTime: _parseTime(json['closingTime']),
    );
  }
  static DateTime? _parseTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
      parts.length > 2 ? int.parse(parts[2]) : 0,
    );
  }
}

final String _baseUrl = dotenv.get('API_URL');

Future<List<BranchData>> getBranch() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/branch'),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    debugPrint('getBranch failed: ${response.statusCode} - ${response.body}');
    branches = [];
    return [];
  } else {
    final List<dynamic> jsonList = jsonDecode(response.body);
    branches = jsonList.map((item) => BranchData.fromJson(item)).toList();
    return branches;
  }
}
