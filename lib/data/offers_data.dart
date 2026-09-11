import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OfferModel {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final double? discountPercentage;
  final num? bundlePrice;
  final String startDate;
  final String endDate;
  final bool isActive;
  final String status;
  final int requestsCount;
  final int productsCount;
  final double totalOfferPrice;
  final List<OfferProductModel> products;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.discountPercentage,
    this.bundlePrice,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.status,
    required this.requestsCount,
    required this.productsCount,
    required this.totalOfferPrice,
    required this.products,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble(),
      bundlePrice: json['bundlePrice'],
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      isActive: json['isActive'] ?? false,
      status: json['status'] ?? '',
      requestsCount: json['requestsCount'] ?? 0,
      productsCount: json['productsCount'] ?? 0,
      totalOfferPrice: (json['totalOfferPrice'] as num?)?.toDouble() ?? 0.0,
      products: (json['products'] as List)
          .map((p) => OfferProductModel.fromJson(p))
          .toList(),
    );
  }
}

class OfferProductModel {
  final int productId;
  final String productName;
  final String productImage;
  final double originalPrice;
  final double finalPrice;
  final int quantity;

  OfferProductModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.originalPrice,
    required this.finalPrice,
    required this.quantity,
  });

  factory OfferProductModel.fromJson(Map<String, dynamic> json) {
    return OfferProductModel(
      productId: json['productId'],
      productName: json['productName'] ?? '',
      productImage: json['productImage'] ?? '',
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['finalPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
    );
  }
}

List<OfferModel> activeOffersData = [];
final String _baseUrl = dotenv.get('API_URL');

Future<List<OfferModel>> getActiveOffers() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/offer/active'),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    debugPrint(
      'getActiveOffers failed: ${response.statusCode} - ${response.body}',
    );
    activeOffersData = [];
    return [];
  } else {
    final responseBody = response.body;
    debugPrint(
      'getActiveOffers success: ${response.statusCode}- ${response.body}',
    );
    activeOffersData = await compute(_decodeOffersInIsolate, responseBody);

    return activeOffersData;
  }
}

List<OfferModel> _decodeOffersInIsolate(String responseBody) {
  final List<dynamic> jsonList = jsonDecode(responseBody);
  return jsonList.map((item) => OfferModel.fromJson(item)).toList();
}

// List<OfferModel> getMockActiveOffers() {
//   return [
//     OfferModel(
//       id: 1,
//       title: 'Summer Super Sale',
//       description:
//           'Discounts on all poultry items with extra bundles for family sizes.',
//       imageUrl:
//           'https://images.pexels.com/photos/5870328/pexels-photo-5870328.jpeg',
//       discountPercentage: 20.0,
//       bundlePrice: null,
//       startDate: '2026-06-01T00:00:00',
//       endDate: '2026-06-30T23:59:59',
//       isActive: true,
//       status: 'Active',
//       requestsCount: 150,
//       productsCount: 2,
//       totalOfferPrice: 240.00,
//       products: [
//         OfferProductModel(
//           productId: 1,
//           productName: 'Frozen Chicken',
//           productImage:
//               'https://images.pexels.com/photos/5870328/pexels-photo-5870328.jpeg',
//           originalPrice: 150.00,
//           finalPrice: 120.00,
//           quantity: 2,
//         ),
//       ],
//     ),
//     OfferModel(
//       id: 2,
//       title: 'Weekend Mega Bundle',
//       description:
//           'Special weekend-only combo discounts on fresh meat and poultry.',
//       imageUrl:
//           'https://images.pexels.com/photos/5870328/pexels-photo-5870328.jpeg',
//       discountPercentage: 15.0,
//       bundlePrice: 199.99,
//       startDate: '2026-06-05T00:00:00',
//       endDate: '2026-06-07T23:59:59',
//       isActive: true,
//       status: 'Active',
//       requestsCount: 85,
//       productsCount: 1,
//       totalOfferPrice: 199.99,
//       products: [
//         OfferProductModel(
//           productId: 2,
//           productName: 'Family Meat Pack',
//           productImage:
//               'https://images.pexels.com/photos/5870328/pexels-photo-5870328.jpeg',
//           originalPrice: 235.00,
//           finalPrice: 199.99,
//           quantity: 1,
//         ),
//       ],
//     ),
//   ];
// }
