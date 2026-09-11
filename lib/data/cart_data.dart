import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:the_project/managers/auth_manage.dart';

class CartItemModel {
  final int productId;
  final String productName;
  final double unitPrice;
  final double finalPrice;
  final num? discountPercentage;
  int quantity;
  final double? subtotal;
  final String productImage;
  final bool isAvailable;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.finalPrice,
    this.discountPercentage,
    required this.quantity,
    this.subtotal,
    required this.productImage,
    required this.isAvailable,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'],
      productName: json['productName'],
      unitPrice: (json['unitPrice'] as num).toDouble(),
      finalPrice: (json['finalPrice'] as num).toDouble(),
      discountPercentage: json['discountPercentage'],
      quantity: json['quantity'],
      subtotal: (json['subtotal'] as num).toDouble(),
      productImage: json['productImage'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}

class CartResponse {
  final List<CartItemModel> items;
  final double totalPrice;
  final int totalItems;

  CartResponse({
    required this.items,
    required this.totalPrice,
    required this.totalItems,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    return CartResponse(
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      totalItems: json['totalItems'],
    );
  }
}

List<CartItemModel> cartdata = [];

class CartService {
  static final String _baseUrl = dotenv.get('API_URL');

  static Future<CartResponse> getCart() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint('get cart failed: ${response.statusCode} - ${response.body}');
      cartdata = [];
      throw Exception('Failed to load cart');
    } else {
      debugPrint('get cart success: ${response.statusCode}');
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);

      final List<dynamic> jsonList = jsonMap['items'];
      cartdata = jsonList.map((item) => CartItemModel.fromJson(item)).toList();

      return CartResponse.fromJson(jsonMap);
    }
  }

  static Future<void> addToCart(int productId, int quantity) async {
    await http.post(
      Uri.parse('$_baseUrl/cart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
      body: jsonEncode({'productId': productId, 'quantity': quantity}),
    );
  }

  static Future<void> updateCartQuantity(int productId, int quantity) async {
    await http.put(
      Uri.parse('$_baseUrl/cart/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
      body: jsonEncode({'quantity': quantity}),
    );
  }

  static Future<void> removeCartItem(int productId) async {
    await http.delete(
      Uri.parse('$_baseUrl/cart/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
    );
  }

  static Future<void> clearCart() async {
    await http.delete(
      Uri.parse('$_baseUrl/cart'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
    );
  }
}
