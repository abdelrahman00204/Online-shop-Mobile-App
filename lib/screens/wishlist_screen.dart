import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/wish_list_data.dart';
import 'package:the_project/screens/cart_screen.dart';
import 'package:the_project/screens/chat_screen.dart';
import 'package:the_project/screens/home_screen.dart';
import 'package:the_project/screens/shop_screen.dart';
import 'package:the_project/widgets/customsearch.dart';
import 'package:the_project/widgets/wishlist_item.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showSearch(context: context, delegate: Customsearch());
          },
          icon: Icon(Icons.search),
        ),
        automaticallyImplyLeading: false,
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
            if (_selectedIndex == 1) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ShopScreen()),
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
      body: Column(
        children: [
          wishlist.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'wishlist.empty_message'.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio:
                              0.5, // tweak if cards overflow or look squished
                        ),
                    itemCount: wishlist.length,
                    itemBuilder: (context, index) {
                      return WishlistItem(
                        id: wishlist[index].productId,
                        onRemove: () => setState(() {}),
                        key: ValueKey(wishlist[index]),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
