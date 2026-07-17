import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/dummy_data.dart';
import 'package:the_project/screens/cart_screen.dart';
import 'package:the_project/screens/wishlist_screen.dart';
import 'package:the_project/widgets/quantity_stepper.dart';
import 'package:the_project/widgets/wishlist_item.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:the_project/widgets/cart_item.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key, required this.product});
  final Product product;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 10),

              SizedBox(
                width: 350,
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(widget.product.imageUrl),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.product.name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'item.description_label'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.product.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'item.availability_label'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.product.inStock
                          ? 'item.in_stock'.tr()
                          : 'item.not_available'.tr(),
                      style: TextStyle(
                        color: widget.product.inStock
                            ? Colors.green[600]
                            : Colors.red[600],
                      ),
                    ),
                    SizedBox(width: 80),
                    Text(
                      'item.unit_label'.tr(args: [widget.product.unit]),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'item.price_label'.tr(
                        args: [widget.product.price.toString()],
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    QuantityStepper(
                      quantity: _quantity,
                      onChanged: (newQuantity) =>
                          setState(() => _quantity = newQuantity),
                    ),
                    SizedBox(width: 100),
                    ElevatedButton.icon(
                      onPressed: () {
                        final productIndex = dummyProducts.indexOf(
                          widget.product,
                        );
                        final existingIndex = cartdata.indexWhere(
                          (item) => item.index1 == productIndex,
                        );

                        setState(() {
                          if (existingIndex != -1) {
                            cartdata[existingIndex].quantity += _quantity;
                          } else {
                            cartdata.add(
                              Helpers(
                                index1: productIndex,
                                quantity: _quantity,
                              ),
                            );
                          }
                        });
                      },
                      label: Text('item.add_to_cart'.tr()),
                      icon: Icon(Icons.shopping_cart),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    OutlinedButton(onPressed: () {}, child: Text('common.buy_now'.tr())),
                    SizedBox(width: 50),
                    wishlistData.contains(widget.product)
                        ? Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const WishlistScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.favorite),
                              label: Text('item.go_to_wishlist'.tr()),
                            ),
                          )
                        : Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  // or wherever your source list is
                                  if (!wishlistData.contains(widget.product)) {
                                    wishlistData.add(widget.product);
                                  }
                                  widget.product.isFavorite = true;
                                });
                              },
                              icon: Icon(Icons.favorite),
                              label: Text('item.add_to_wishlist'.tr()),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
