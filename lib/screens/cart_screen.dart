import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/cart_data.dart';
import 'package:the_project/widgets/cart_item.dart';
import 'package:the_project/widgets/checkout_dialog.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  double get _amountToPay {
    return cartdata.fold<double>(
      0,
      (sum, item) => sum + (item.finalPrice * item.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Al_ghoul_2.jpg', height: 80, width: 200),
        actions: [],
      ),
      body: Column(
        children: [
          cartdata.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'cart.empty_message'.tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: cartdata.length,
                    itemBuilder: (context, index) {
                      return CartItem(
                        productId: cartdata[index].productId,
                        onRemove: () => setState(() {}),
                      );
                    },
                  ),
                ),
          SizedBox(height: 24),
          cartdata.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '$_amountToPay EGP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            showCheckoutDialog(
                              context,
                              amountToPay: _amountToPay,
                            );
                          },
                          child: Text('common.buy_now'.tr()),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
