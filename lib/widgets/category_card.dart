import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_project/data/categories_data.dart';
import 'package:the_project/screens/categories_screen.dart';

class MainCategoryCard extends StatefulWidget {
  final MainCategories category;
  final VoidCallback? onSubCategoryTap;

  const MainCategoryCard({
    super.key,
    required this.category,
    this.onSubCategoryTap,
  });

  @override
  State<MainCategoryCard> createState() => _MainCategoryCardState();
}

class _MainCategoryCardState extends State<MainCategoryCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final previewImages = widget.category.subs!
        .map((sub) => sub.imageUrl)
        .take(2)
        .toList();

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded ? const Color(0xFF00B251) : Colors.green.shade200,
            width: isExpanded ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00B251),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 2; i++)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 95,
                        height: 75,
                        color: Colors.grey.shade100,
                        child: i < previewImages.length
                            ? CachedNetworkImage(
                                imageUrl: previewImages[i],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.broken_image,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                              )
                            : Image.network(
                                widget.category.imageUrl,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                ],
              ),

              // Expanded Subcategories Section
              if (isExpanded && widget.category.subs!.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(thickness: 1, color: Colors.black12),
                ),
                Column(
                  children: widget.category.subs!.map((subCategory) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoriesScreen(name: subCategory.name),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: subCategory.imageUrl,
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                          title: Text(
                            subCategory.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xFF00B251),
                          ),
                          onTap: widget.onSubCategoryTap,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
