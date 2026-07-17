import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/categories_data.dart';
import 'package:the_project/screens/cart_screen.dart';
import 'package:the_project/screens/profile_screen.dart';
import 'package:the_project/screens/shop_screen.dart';
import 'package:the_project/screens/wishlist_screen.dart';
import 'package:the_project/widgets/categories_row.dart';
import 'package:the_project/widgets/customsearch.dart';
import 'package:the_project/widgets/page_view_home.dart';
import 'login_screen.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Widget loggedInDrop() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.person),
      onSelected: (value) async {
        if (value == 'profile') {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProfileScreen()),
          );
          if (context.mounted) {
            setState(
              () {},
            ); // NEW: force Home (and its children) to rebuild once we're back
          }
        } else if (value == 'logout') {
          await AuthManage.instance.logout();
          setState(() {});
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'profile', child: Text('home.profile_menu'.tr())),
        PopupMenuItem(value: 'logout', child: Text('home.logout_menu'.tr())),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Al_ghoul_2.jpg', height: 80, width: 200),
        leadingWidth: 90,
        leading: AuthManage.instance.isLoggedIn
            ? loggedInDrop()
            : IconButton(
                icon: Icon(Icons.person_pin),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  setState(() {});
                },
              ),
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (_selectedIndex == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ShopScreen()),
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

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            SizedBox(height: 6),
            PageViewHome(),
            SizedBox(height: 12),
            Text(
              'home.categories'.tr(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CategoriesRow(),
            SizedBox(height: 16),
            Text(
              'home.offers'.tr(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            for (final category in categories)
              CachedNetworkImage(
                imageUrl: category.imageUrl,
                width: 100,
                height: 100,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image_outlined),
              ),
          ],
        ),
      ),
    );
  }
}
