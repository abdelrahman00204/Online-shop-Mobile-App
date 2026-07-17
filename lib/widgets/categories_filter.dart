import 'package:flutter/material.dart';
import 'package:the_project/dummy_data.dart';

class CategoriesFilter extends StatelessWidget {
  final List<bool> categoryState;
  final void Function(int index, bool val) onChanged;

  const CategoriesFilter({
    super.key,
    required this.categoryState,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: dummyCategories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return CheckboxListTile(
              title: Text('All'),
              value: categoryState.every((e) => e),
              onChanged: (val) => onChanged(-1, val!),
            );
          }
          return CheckboxListTile(
            title: Text(dummyCategories[index-1].name),
            value: categoryState[index-1],
            onChanged: (val) => onChanged(index-1, val!),
          );
        },
      ),
    );
  }
}
