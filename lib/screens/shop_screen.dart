import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/dummy_data.dart';
import 'package:the_project/screens/cart_screen.dart';
import 'package:the_project/screens/chat_screen.dart';
import 'package:the_project/screens/home_screen.dart';
import 'package:the_project/screens/wishlist_screen.dart';
import 'package:the_project/widgets/categories_filter.dart';
import 'package:the_project/widgets/customsearch.dart';
import 'package:the_project/widgets/items.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductCategory? selectedCategory;
  static String? selectedBranchId = 'b1';

  static List<bool> categoryState = List.filled(dummyCategories.length, true);
  List<Product> get filteredProducts {
    return dummyProducts.where((p) {
      final categoryIndex = dummyCategories.indexWhere(
        (c) => c.id == p.categoryId,
      );
      final categoryAllowed = categoryState[categoryIndex];
      final branchAllowed =
          selectedBranchId == null || p.branchIds.contains(selectedBranchId);
      return categoryAllowed && branchAllowed;
    }).toList();
  }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      drawer: CategoriesFilter(
        categoryState: categoryState,
        onChanged: (index, val) {
          setState(() {
            if (index == -1) {
              // toggle all
              categoryState = List.filled(dummyCategories.length, val);
            } else {
              categoryState[index] = val;
            }
          });
        },
      ),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            showSearch(context: context, delegate: Customsearch());
          },
          icon: Icon(Icons.search),
        ),
        title: Image.asset('assets/Al_ghoul_2.jpg', height: 80, width: 200),
        /* */
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
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (_selectedIndex == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
            if (_selectedIndex == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
              );
            }
            if (_selectedIndex == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'common.nav_home'.tr()),
          BottomNavigationBarItem(icon: Icon(Icons.shopify), label: 'common.nav_shop'.tr()),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'common.nav_wishlist'.tr(),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'common.nav_ai_chat'.tr()),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    label: Text('shop.filter_button'.tr()),
                    icon: Icon(Icons.tune),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedBranchId,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF2E7D32),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: const Color(0xFF2E7D32).withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF2E7D32),
                            width: 2,
                          ),
                        ),
                      ),
                      dropdownColor: Colors.white,
                      iconEnabledColor: const Color(0xFF2E7D32),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
                      items: [
                        for (final branch in dummyBranches)
                          DropdownMenuItem(
                            value: branch.id,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.store_outlined,
                                  color: Color(0xFF2E7D32),
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(branch.name),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedBranchId = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return Items(product: filteredProducts[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
