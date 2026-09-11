import 'package:flutter/material.dart';
import 'package:the_project/data/product_data.dart';
import 'package:the_project/widgets/items.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;

  const SearchResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // 1. Filter the products list using the searchQuery
    final cleanQuery = searchQuery.trim().toLowerCase();
    final List<Products> matchingProducts = products.where((product) {
      return product.name.toLowerCase().contains(cleanQuery) ||
          product.categoryName.toLowerCase().contains(cleanQuery) ||
          product.brandName.toLowerCase().contains(cleanQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Results for "$searchQuery"')),
      body: matchingProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No items found matching "$searchQuery"',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          // 3. Render matching items in a GridView
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.5,
              ),
              itemCount: matchingProducts.length,
              itemBuilder: (context, index) {
                return Items(product: matchingProducts[index]);
              },
            ),
    );
  }
}
