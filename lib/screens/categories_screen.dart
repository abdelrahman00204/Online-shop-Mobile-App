import 'package:flutter/material.dart';
import 'package:the_project/data/product_data.dart';
import 'package:the_project/screens/cart_screen.dart';
import 'package:the_project/widgets/customsearch.dart';
import 'package:the_project/widgets/items.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.name});
  final String name;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Products> get filteredProducts {
    return products.where((p) {
      return p.categoryName == widget.name;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Al_ghoul_2.jpg', height: 80, width: 200),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Customsearch());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      // CHANGED: Removed the Expanded widget wrapping GridView.builder
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.45,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          return Items(product: filteredProducts[index]);
        },
      ),
    );
  }
} 