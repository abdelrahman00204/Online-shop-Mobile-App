import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
            if (_selectedIndex == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ShopScreen()),
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
          wishlistData.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'wishlist.empty_message'.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: wishlistData.length,
                    itemBuilder: (context, index) {
                      return WishlistItem(
                        index: index,
                        onRemove: () => setState(() {}),
                        key: ValueKey(wishlistData[index]),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
