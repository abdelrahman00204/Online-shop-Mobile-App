import 'package:flutter/material.dart';
import 'package:the_project/dummy_data.dart';
import 'package:the_project/screens/item_screen.dart';

class Customsearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
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
    List<Product> matchquery = [];
    for (var product in dummyProducts) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchquery.add(product);
      }
    }

    return ListView.builder(
      itemCount: matchquery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchquery[index].name),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemScreen(product: matchquery[index]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return const SizedBox.shrink();
    List<Product> matchquery = [];
    for (var product in dummyProducts) {
      if (product.name.toLowerCase().contains(query.toLowerCase())) {
        matchquery.add(product);
      }
    }

    return ListView.builder(
      itemCount: matchquery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchquery[index].name),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemScreen(product: matchquery[index]),
              ),
            );
          },
        );
      },
    );
  }
}
