import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/categories_data.dart';
import 'package:the_project/screens/categories_screen.dart';

class CategoriesRow extends StatefulWidget {
  const CategoriesRow({super.key});

  @override
  State<CategoriesRow> createState() => _CategoriesRowState();
}

class _CategoriesRowState extends State<CategoriesRow> {
  MainCategories? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final category in categories)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selectedCategory == category) {
                        selectedCategory = null;
                      } else {
                        selectedCategory = category;
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: selectedCategory == category
                              ? Colors.green.shade300
                              : Colors.green.shade100,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: category
                                  .imageUrl, 
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.image_not_supported_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: selectedCategory == category
                                ? Colors.green.shade800
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // 2. Dynamic Subcategories Row (Appears when a main category is selected)
        if (selectedCategory != null &&
            selectedCategory!.subs!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Subcategories for ${selectedCategory!.name}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final subCategory in selectedCategory!.subs!)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ActionChip(
                      backgroundColor: Colors.grey.shade100,
                      label: Text(subCategory.name),
                      onPressed: () {
                        // Navigate to your CategoriesScreen or Products screen when a subcategory is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CategoriesScreen(name: subCategory.name),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
