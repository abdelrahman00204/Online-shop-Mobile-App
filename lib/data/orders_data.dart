import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_project/managers/auth_manage.dart';

class OrderItem {
  final int productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      quantity: json['quantity'],
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OrderResponse {
  final int id;
  final String orderNumber;
  final String status;
  final double totalPrice;
  final String? notes;
  final DateTime createdAt;
  final String branchName;
  final String customerName;
  final List<OrderItem> items;

  OrderResponse({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalPrice,
    this.notes,
    required this.createdAt,
    required this.branchName,
    required this.customerName,
    required this.items,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['id'],
      orderNumber: json['orderNumber'],
      status: json['status'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      branchName: json['branchName'],
      customerName: json['customerName'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}


List<OrderResponse> myorders = [];

final String _baseUrl = dotenv.get('API_URL');

Future<List<OrderResponse>> getOrders() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/order/my'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthManage.instance.userToken}',
    },
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    debugPrint('make order failed: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to make order');
  } else {
    debugPrint('make order success: ${response.statusCode} - ${response.body}');
    final List<dynamic> jsonList = jsonDecode(response.body);
    myorders = jsonList.map((item) => OrderResponse.fromJson(item)).toList();

    return myorders;
  }
}

Future<void> cancelOrder(int orderId) async {
  final response = await http.delete(
    Uri.parse('$_baseUrl/order/my/$orderId/cancel'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthManage.instance.userToken}',
    },
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    debugPrint('make order failed: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to make order');
  } else {
    debugPrint('make order success: ${response.statusCode} - ${response.body}');
    myorders.removeWhere((order) => order.id == orderId);
  }
}
