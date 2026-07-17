import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MainCategories {
  int id;
  String name;
  String imageUrl;
  List<SubCategories>? subs;
  int? productsCount;

  MainCategories({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.subs,
    this.productsCount,
  });

  factory MainCategories.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['imageUrl'] as String;
    final fullImageUrl = _resolveImageUrl(rawUrl);
    print('Full image URL: $fullImageUrl');
    return MainCategories(
      id: json['id'],
      name: json['name'],
      imageUrl: fullImageUrl,
      productsCount: json['productsCount'],
      subs: json['subCategories'] != null
          ? (json['subCategories'] as List)
                .map((sub) => SubCategories.fromJson(sub))
                .toList()
          : null,
    );
  }
}

class SubCategories {
  int id;
  String name;
  String imageUrl;
  int parentCategoryId;
  int? productsCount;

  SubCategories({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.parentCategoryId,
    this.productsCount,
  });

  factory SubCategories.fromJson(Map<String, dynamic> json) {
    return SubCategories(
      id: json['id'],
      name: json['name'],
      imageUrl: _resolveImageUrl(json['imageUrl'] as String),
      parentCategoryId: json['parentCategoryId'],
      productsCount: json['productsCount'],
    );
  }
}

String _resolveImageUrl(String rawUrl) {
  if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
    return rawUrl; // already a full URL (e.g. blob storage) — use as-is
  }
  final path = rawUrl.replaceAll(RegExp(r'^/+'), '');
  return '$_imageBaseUrl/$path';
}

List<MainCategories> categories = [];
final String _baseUrl = dotenv.get('API_URL');
final String _imageBaseUrl = _baseUrl.endsWith('/api')
    ? _baseUrl.substring(0, _baseUrl.length - 4)
    : _baseUrl;

Future<List<MainCategories>> getCategories() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/category'),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    print('getCategories failed: ${response.statusCode} - ${response.body}');
    categories = [];
    return [];
  } else {
    final List<dynamic> jsonList = jsonDecode(response.body);
    categories = jsonList.map((item) => MainCategories.fromJson(item)).toList();
    print('getCategories success: ${response.statusCode} - ${response.body}');

    return categories;
  }
}
