import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/screens/cart_screen.dart';
import 'package:the_project/screens/chat_screen.dart';
import 'package:the_project/screens/home_screen.dart';
import 'package:the_project/screens/wishlist_screen.dart';
import 'package:the_project/widgets/branch_filter.dart';
import 'package:the_project/widgets/categories_row.dart';
import 'package:the_project/widgets/customsearch.dart';
import 'package:the_project/widgets/items.dart';
import 'package:the_project/data/product_data.dart';
import 'package:the_project/data/categories_data.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MainCategories? selectedCategory;

  late List<bool> categoryState;

  @override
  void initState() {
    super.initState();
    categoryState = List.filled(categories.length, true);
  }

  // List<Products> get filteredProducts {
  //   return products.where((p) {
  //     final matchedSub = subCategories.firstWhere(
  //       (s) => s.name == p.categoryName,
  //     );
  //     final categoryIndex = categories.indexWhere(
  //       (c) => c.id == matchedSub.parentCategoryId,
  //     );
  //     final categoryAllowed = categoryState[(categoryIndex)];
  //     /*final branchAllowed =
  //         selectedBranchId == null || p.branchIds.contains(selectedBranchId);*/
  //     return categoryAllowed; //&& branchAllowed;
  //   }).toList();
  // }

  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      // drawer: CategoriesFilter(
      //   categoryState: categoryState,
      //   onChanged: (index, val) {
      //     setState(() {
      //       if (index == -1) {
      //         // toggle all
      //         categoryState = List.filled(categories.length, val);
      //       } else {
      //         categoryState[index] = val;
      //       }
      //     });
      //   },
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            showSearch(context: context, delegate: Customsearch());
          },
          icon: Icon(Icons.search),
        ),
        // title: Image.asset('assets/Al_ghoul_2.jpg', height: 80, width: 200),
        /* */
        actions: [
          BranchFilter(),
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            }
            if (_selectedIndex == 2) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
                (route) => false,
              );
            }
            if (_selectedIndex == 3) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
                (route) => false,
              );
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'common.nav_home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopify),
            label: 'common.nav_shop'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'common.nav_wishlist'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'common.nav_ai_chat'.tr(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home.categories'.tr(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              CategoriesRow(),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     _scaffoldKey.currentState?.openDrawer();
              //   },
              //   label: Text('shop.filter_button'.tr()),
              //   icon: Icon(Icons.tune),
              // ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.45,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Items(product: products[index]);
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
