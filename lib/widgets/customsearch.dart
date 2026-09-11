import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/product_data.dart';
import 'package:the_project/screens/item_screen.dart';
import 'package:the_project/screens/search_results_screen.dart';

class Customsearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(
        child: Text(
          'Please enter a search term',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // Schedule navigation right after the current frame to prevent state conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchQuery = query;
      close(context, null); // Close the search delegate UI

      Navigator.push(
        context,
        MaterialPageRoute(
          // Replace SearchResultsScreen with your actual full-page results widget
          builder: (context) => SearchResultsScreen(searchQuery: searchQuery),
        ),
      );
    });
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Start typing to search products',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return _buildProductList(context);
  }

  // NEW — shared logic for both buildResults and buildSuggestions
  Widget _buildProductList(BuildContext context) {
    final q = query.toLowerCase();
    final matchquery = products.where((product) {
      return product.name.toLowerCase().contains(q) ||
          product.categoryName.toLowerCase().contains(q) ||
          product.brandName.toLowerCase().contains(q);
    }).toList();

    if (matchquery.isEmpty) {
      return const Center(
        child: Text('No products found', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      itemCount: matchquery.length,
      itemBuilder: (context, index) {
        final product = matchquery[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: product.images.isNotEmpty ? product.images[0].url : '',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) =>
                  const Icon(Icons.image, size: 30, color: Colors.grey),
            ),
          ),
          title: Text(product.name),
          subtitle: Text('${product.newPrice} EGP'), // NEW
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemScreen(id: product.id),
              ),
            );
          },
        );
      },
    );
  }
}
