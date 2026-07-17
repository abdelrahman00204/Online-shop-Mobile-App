import 'package:flutter/material.dart';
import 'package:the_project/dummy_data.dart';
import 'package:the_project/screens/item_screen.dart';
import 'package:the_project/widgets/cart_item.dart';
import 'package:the_project/widgets/wishlist_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Items extends StatefulWidget {
  const Items({required this.product, super.key});
  final Product product;

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Card(
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  elevation: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItemScreen(product: widget.product),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.product.imageUrl,
                          fit: BoxFit.cover,
                          height: 170,
                          width: double.infinity,
                          placeholder: (context, url) =>
                              const SizedBox(), // transparent like kTransparentImage
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.broken_image),
                          fadeInDuration: const Duration(
                            milliseconds: 300,
                          ), // keeps the fade effect
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Color.fromARGB(255, 75, 165, 77),
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 8,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                        widget.product.name,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(color: Colors.white),
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Price:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      '${widget.product.price}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(width: 12),
                                    if (widget.product.inStock)
                                      Text(
                                        'Available',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    else
                                      Text(
                                        'Not Available',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () {
                              final productIndex = dummyProducts.indexOf(
                                widget.product,
                              );
                              final existingIndex = cartdata.indexWhere(
                                (item) => item.index1 == productIndex,
                              );

                              setState(() {
                                if (existingIndex != -1) {
                                  cartdata[existingIndex].quantity += 1;
                                } else {
                                  cartdata.add(
                                    Helpers(index1: productIndex, quantity: 1),
                                  );
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.shopping_cart,
                              size: 22,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        if (!wishlistData.contains(widget.product)) {
                          wishlistData.add(widget.product);
                          _isFavorite = true;
                        } else {
                          if (wishlistData.contains(widget.product)) {
                            wishlistData.remove(widget.product);
                            _isFavorite = false;
                          }
                        }
                      });
                    },
                    icon: Icon(
                      Icons.favorite,
                      size: 22,
                      color: _isFavorite
                          ? Color.fromARGB(255, 75, 165, 77)
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
