import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/screens/home_screen.dart';
import 'package:the_project/screens/login_screen.dart';
import 'package:the_project/screens/shop_screen.dart';
import 'package:the_project/screens/wishlist_screen.dart';
import 'package:the_project/widgets/chat_storage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _sendController = TextEditingController();

  List<Message> get message => messages;
  int _selectedIndex = 3;

  @override
  void dispose() {
    _sendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('chat.title'.tr())),
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
            if (_selectedIndex == 2) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WishlistScreen()),
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
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GroupedListView<Message, DateTime>(
                  reverse: true,
                  order: GroupedListOrder.DESC,
                  floatingHeader: true,
                  useStickyGroupSeparators: true,
                  elements: message, // Your list of chat messages
                  groupBy: (message) => DateTime(
                    message.date.year,
                    message.date.month,
                    message.date.day,
                  ), // Group by date
                  groupHeaderBuilder: (Message message) => SizedBox(
                    height: 40,
                    child: Center(
                      child: Text(
                        DateFormat.yMMMd().format(message.date),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  itemBuilder: (context, Message message) => BubbleSpecialThree(
                    text: message.message,
                    isSender: message.isSender,
                    color: message.isSender
                        ? Color.fromARGB(255, 75, 165, 77)
                        : Color.fromARGB(255, 178, 178, 178),
                    tail: false,
                    textStyle: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _sendController,
                        decoration: InputDecoration(
                          hintText: 'chat.message_hint'.tr(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final text = _sendController.text.trim();
                        if (text.isEmpty) return;

                        setState(() {
                          message.add(
                            Message(
                              message: text,
                              isSender: true,
                              date: DateTime.now(),
                            ),
                          );
                        });
                        _sendController.clear();

                        final success = await query(text);
                        if (success) {
                          setState(
                            () {},
                          ); // triggers rebuild now that the reply is in `messages`
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!AuthManage.instance.isLoggedIn)
            Positioned.fill(
              child: AbsorbPointer(
                absorbing:
                    true, // blocks all taps/scrolling to what's underneath
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.5,
                  ), // dim effect, shows content underneath
                ),
              ),
            ),
          if (!AuthManage.instance.isLoggedIn)
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  setState(() {});
                },
                child: Text('common.login'.tr()),
              ),
            ),
        ],
      ),
    );
  }
}
