import 'package:flutter/material.dart';
import 'package:the_project/screens/cart_screen.dart';
import 'package:the_project/widgets/customsearch.dart';
import 'package:the_project/dummy_data.dart';
import 'package:the_project/widgets/items.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.id});
  final int id;
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Product> get filteredProducts {
    return dummyProducts.where((p) {
      return int.parse(p.categoryId) == widget.id;
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
            icon: Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Customsearch());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, i) {
          return Items(product: filteredProducts[i]);
        },
      ),
    );
  }
}
