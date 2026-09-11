import 'package:flutter/material.dart';
import 'package:the_project/data/cart_data.dart';
import 'package:the_project/data/product_data.dart';
import 'package:the_project/data/wish_list_data.dart';
import 'package:the_project/screens/item_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Items extends StatefulWidget {
  const Items({required this.product, super.key});
  final Products product;

  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  late bool _isInWishlist;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    _isInWishlist = wishlist.any((item) => item.productId == widget.product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemScreen(id: widget.product.id),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.product.images[0].url,
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              if (widget.product.discountPercentage != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 205, 57, 40),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${widget.product.discountPercentage}% off',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: () async {
                    final wasInWishlist = _isInWishlist;
                    setState(() => _isInWishlist = !wasInWishlist);

                    try {
                      if (!wasInWishlist) {
                        await addToWishlist(widget.product.id);
                      } else {
                        await deleteFromWishlist(widget.product.id);
                      }
                    } catch (e) {
                      if (mounted) {
                        setState(() => _isInWishlist = wasInWishlist);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not update wishlist'),
                          ),
                        );
                      }
                    }
                  },
                  icon: Icon(
                    Icons.favorite,
                    size: 22,
                    color: _isInWishlist
                        ? const Color.fromARGB(255, 75, 165, 77)
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 44,
                  child: Text(
                    widget.product.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.product.discountPercentage != null)
                      Text(
                        '${widget.product.oldPrice}',
                        style: const TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      const SizedBox(),
                    Text(
                      '${widget.product.newPrice}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                isloading
                    ? Center(child: const CircularProgressIndicator())
                    : ElevatedButton.icon(
                        onPressed: () async {
                          // CHANGED: Moved lookup logic outside of setState
                          final existingIndex = cartdata.indexWhere(
                            (item) => item.productId == widget.product.id,
                          );

                          if (existingIndex != -1) {
                            // CHANGED: Update quantity locally inside setState
                            setState(() {
                              cartdata[existingIndex].quantity += 1;
                              isloading = true;
                            });

                            // CHANGED: Await backend update outside of setState using product ID
                            await CartService.updateCartQuantity(
                              widget.product.id,
                              cartdata[existingIndex].quantity,
                            );
                            setState(() {
                              isloading = false;
                            });
                          } else {
                            // CHANGED: Add item locally inside setState
                            setState(() {
                              cartdata.add(
                                CartItemModel(
                                  productId: widget.product.id,
                                  productName: widget.product.name,
                                  unitPrice: widget.product.oldPrice.toDouble(),
                                  finalPrice: widget.product.newPrice
                                      .toDouble(),
                                  discountPercentage:
                                      widget.product.discountPercentage,
                                  quantity: 1,
                                  subtotal: widget.product.newPrice.toDouble(),
                                  productImage: widget.product.images[0].url,
                                  isAvailable: widget.product.isAvailable,
                                ),
                              );
                              isloading = true;
                            });

                            // CHANGED: Await backend add outside of setState
                            await CartService.addToCart(widget.product.id, 1);
                          }
                          setState(() {
                            isloading = false;
                          });
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to cart')),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        label: const Text('Add to cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
