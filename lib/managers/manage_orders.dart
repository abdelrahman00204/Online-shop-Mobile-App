import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:the_project/data/cart_data.dart';
import 'package:the_project/data/offers_data.dart';
import 'package:the_project/data/orders_data.dart';
import 'package:the_project/managers/auth_manage.dart';

class ManageOrders {
  final String _baseUrl = dotenv.get('API_URL');

  Future<OrderResponse> makeOrder(int branchId, int? offerId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/order'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
      body: jsonEncode({
        'branchId': branchId,
        'offerId': offerId,
        'items': offerId == null
            ? cartdata
                  .map(
                    (item) => {
                      'productId': item.productId,
                      'quantity': item.quantity,
                    },
                  )
                  .toList()
            : activeOffersData
                  .firstWhere((offer) => offer.id == offerId)
                  .products
                  .map(
                    (product) => {
                      'productId': product.productId,
                      'quantity': product.quantity,
                    },
                  )
                  .toList(),
      }),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint(
        'make order failed: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Failed to make order: ${response.body}');
    } else {
      debugPrint(
        'make order success: ${response.statusCode} - ${response.body}',
      );
      final decoded = jsonDecode(response.body);
      return OrderResponse.fromJson(decoded);
    }
  }
}
