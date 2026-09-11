import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_project/managers/auth_manage.dart';

class WishlistProducts {
  int productId;
  String productName;
  num oldPrice;
  num newPrice;
  num? discountPercentage;
  bool hasDiscount;
  String productImage;
  bool isAvailable;

  WishlistProducts({
    required this.productId,
    required this.productName,
    required this.oldPrice,
    required this.newPrice,
    this.discountPercentage,
    required this.hasDiscount,
    required this.productImage,
    required this.isAvailable,
  });

  factory WishlistProducts.fromJson(Map<String, dynamic> json) {
    return WishlistProducts(
      productId: json['productId'],
      productName: json['productName'],
      oldPrice: json['oldPrice'],
      newPrice: json['newPrice'],
      discountPercentage: json['discountPercentage'],
      hasDiscount: json['hasDiscount'],
      productImage: json['productImage'],
      isAvailable: json['isAvailable'],
    );
  }
}

List<WishlistProducts> wishlist = [];
final String _baseUrl = dotenv.get('API_URL');

Future<List<WishlistProducts>> getWishlist() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/wishlist'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthManage.instance.userToken}',
    },
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    debugPrint('getWishlist failed: ${response.statusCode} - ${response.body}');
    debugPrint('${AuthManage.instance.userToken}');

    wishlist = [];

    throw Exception('Failed to add to wishlist');
  } else {
    final List<dynamic> jsonList = jsonDecode(response.body);
    wishlist = jsonList.map((item) => WishlistProducts.fromJson(item)).toList();
    debugPrint('getWishlist success: ${response.statusCode} - ${response.body}');
    debugPrint('${AuthManage.instance.userToken}');

    return wishlist;
  }
}

Future<void> addToWishlist(int productId) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/wishlist/$productId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthManage.instance.userToken}',
    },
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    debugPrint('addToWishlist failed: ${response.statusCode} - ${response.body}');
    debugPrint('${AuthManage.instance.userToken}');
    throw Exception('Failed to add to wishlist');
  } else {
    debugPrint('addToWishlist success: ${response.statusCode} - ${response.body}');
    await getWishlist();
  }
}

Future<void> deleteFromWishlist(int productId) async {
  final response = await http.delete(
    Uri.parse('$_baseUrl/wishlist/$productId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthManage.instance.userToken}',
    },
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    debugPrint(
      'deleteFromWishlist failed: ${response.statusCode} - ${response.body}',
    );
    throw Exception('Failed to add to wishlist');
  } else {
    debugPrint(
      'deleteFromWishlist success: ${response.statusCode} - ${response.body}',
    );
    await getWishlist();
  }
}

// Future<bool> isProductInWishlist(int productId) async {
//   final response = await http.get(
//     Uri.parse('$_baseUrl/wishlist/check/${AuthManage.instance.userToken}'),
//     headers: {'Content-Type': 'application/json'},
//   );
//   if (response.statusCode != 200 && response.statusCode != 201) {
//     print(
//       'isProductInWishlist failed: ${response.statusCode} - ${response.body}',
//     );
//     return false;
//   } else {
//     final jsonList = jsonDecode(response.body);
//    return jsonList['isInWishlist'] ;

//   }
// }
