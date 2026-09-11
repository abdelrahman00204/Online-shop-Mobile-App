import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Products {
  int id;
  String name;
  num oldPrice;
  num newPrice;
  num? discountPercentage;
  bool hasDiscount;
  String unitType;
  String? description;
  List<Images> images;
  num weight;
  String categoryName;
  String brandName;
  num averageRating;
  num reviewsCount;
  bool isAvailable;

  Products({
    required this.id,
    required this.name,
    required this.oldPrice,
    required this.newPrice,
    this.discountPercentage,
    required this.hasDiscount,
    required this.unitType,
    this.description,
    required this.images,
    required this.weight,
    required this.categoryName,
    required this.brandName,
    required this.averageRating,
    required this.reviewsCount,
    required this.isAvailable,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      oldPrice: json['oldPrice'],
      newPrice: json['newPrice'],
      discountPercentage: json['discountPercentage'],
      hasDiscount: json['hasDiscount'],
      unitType: json['unitType'],
      description: json['description'],
      images: (json['images'] as List)
          .map((img) => Images.fromJson(img))
          .toList(),
      weight: json['weight'] ?? 0,
      categoryName: json['categoryName'],
      brandName: json['brandName'] ?? '',
      averageRating: json['averageRating'],
      reviewsCount: json['reviewsCount'],
      isAvailable: json['isAvailable'],
    );
  }
}

class Images {
  int id;
  String url;
  int displayOrder;

  Images({required this.id, required this.url, required this.displayOrder});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['id'],
      url: (json['url']),
      displayOrder: json['displayOrder'],
    );
  }
}

/*String _resolveImageUrl(String rawUrl) {
  if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
    return rawUrl;
  }
  final path = rawUrl.replaceAll(RegExp(r'^/+'), '');
  return '$_imageBaseUrl/$path';
}*/

List<Products> products = [];
List<Products> discountedProducts = [];
final String _baseUrl = dotenv.get('API_URL');

// final String _imageBaseUrl = _baseUrl.endsWith('/api')
//     ? _baseUrl.substring(0, _baseUrl.length - 4)
//     : _baseUrl;

Future<List<Products>> getProducts() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/product'),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    debugPrint('getProducts failed: ${response.statusCode} - ${response.body}');
    products = [];
    return [];
  } else {
    final responseBody = response.body;

    products = await compute(_decodeProductsInIsolate, responseBody);
    discountedProducts = products.where((p) => p.hasDiscount).toList();

    debugPrint(
      'getProducts success: ${response.statusCode} - ${response.body}',
    );

    return products;
  }
}

List<Products> _decodeProductsInIsolate(String responseBody) {
  final List<dynamic> jsonList = jsonDecode(responseBody);
  return jsonList.map((item) => Products.fromJson(item)).toList();
}
