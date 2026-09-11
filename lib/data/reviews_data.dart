import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:the_project/managers/auth_manage.dart';

class ReviewModel {
  final int id;
  final int customerId;
  final String customerName;
  final int productId;
  final String productName;
  final double rating;
  final String comment;
  final String createdAt;

  ReviewModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.productId,
    required this.productName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      customerId: json['customerId'] ?? 0,
      customerName: json['customerName'] ?? '',
      productId: json['productId'],
      productName: json['productName'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

List<ReviewModel> productReviewsData = [];
List<ReviewModel> myReviewsData = [];

class ReviewService {
  static final String _baseUrl = dotenv.get('API_URL');

  // 83 - Get Product Reviews (Public)
  static Future<List<ReviewModel>> getProductReviews(int productId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/review/product/$productId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint(
        'get product reviews failed: ${response.statusCode} - ${response.body}',
      );
      productReviewsData = [];
      throw Exception('Failed to load product reviews');
    } else {
      debugPrint('get product reviews success: ${response.statusCode}');
      final List<dynamic> jsonList = jsonDecode(response.body);
      productReviewsData = jsonList
          .map((item) => ReviewModel.fromJson(item))
          .toList();
      return productReviewsData;
    }
  }

  // 84 - Get My Reviews (Customer Only)
  static Future<List<ReviewModel>> getMyReviews() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/review/my'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint(
        'get my reviews failed: ${response.statusCode} - ${response.body}',
      );
      myReviewsData = [];
      throw Exception('Failed to load my reviews');
    } else {
      debugPrint('get my reviews success: ${response.statusCode}');
      final List<dynamic> jsonList = jsonDecode(response.body);
      myReviewsData = jsonList
          .map((item) => ReviewModel.fromJson(item))
          .toList();
      return myReviewsData;
    }
  }

  // 85 - Create Review (Customer Only)
  static Future<ReviewModel> createReview({
    required int productId,
    required double rating,
    required String comment,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/review'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
      body: jsonEncode({
        'productId': productId,
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint(
        'create review failed: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Failed to create review');
    } else {
      debugPrint('create review success: ${response.statusCode}');
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return ReviewModel.fromJson(jsonMap);
    }
  }

  // 86 - Update Review (Customer Only)
  static Future<void> updateReview({
    required int reviewId,
    required double rating,
    required String comment,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/review/$reviewId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
      body: jsonEncode({'rating': rating, 'comment': comment}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint(
        'update review failed: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Failed to update review');
    } else {
      debugPrint('update review success: ${response.statusCode}');
    }
  }

  // 87 - Delete Review (Customer Only)
  static Future<void> deleteReview(int reviewId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/review/$reviewId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthManage.instance.userToken}',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint(
        'delete review failed: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Failed to delete review');
    } else {
      debugPrint('delete review success: ${response.statusCode}');
    }
  }
}
