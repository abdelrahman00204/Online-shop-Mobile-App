import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/cart_data.dart';
import 'package:the_project/data/product_data.dart';
import 'package:the_project/screens/item_screen.dart';
import 'package:the_project/data/wish_list_data.dart';

class WishlistItem extends StatefulWidget {
  const WishlistItem({super.key, required this.id, required this.onRemove});
  final int id;
  final VoidCallback onRemove;
  @override
  State<WishlistItem> createState() => _WishlistItemState();
}

class _WishlistItemState extends State<WishlistItem> {
  void _removeItem() async {
    wishlist.removeWhere((item) => item.productId == widget.id);
    widget.onRemove();
    await deleteFromWishlist(widget.id);
  }

  Products get getProduct => products.firstWhere((p) => p.id == widget.id);

  @override
  Widget build(BuildContext context) {
    if (wishlist.isEmpty) {
      return const SizedBox.shrink();
    }
    final product = wishlist.firstWhere((item) => item.productId == widget.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        builder: (context) => ItemScreen(id: widget.id),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: product.productImage,
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
              if (product.discountPercentage != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${product.discountPercentage}%',
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
                  onPressed: _removeItem,
                  icon: const Icon(Icons.delete, size: 22, color: Colors.black),
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
                  height: 44, // reserves space for up to 2 lines, matches Items
                  child: Center(
                    child: Text(
                      product.productName,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (product.discountPercentage != null)
                      Text(
                        '${product.oldPrice}%',
                        style: const TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    else
                      const SizedBox(),
                    Text(
                      '${product.newPrice}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    final existingIndex = cartdata.indexWhere(
                      (item) => item.productId == widget.id,
                    );

                    if (existingIndex != -1) {
                      setState(() {
                        cartdata[existingIndex].quantity += 1;
                      });

                      await CartService.updateCartQuantity(
                        widget.id,
                        cartdata[existingIndex].quantity,
                      );
                    } else {
                      setState(() {
                        cartdata.add(
                          CartItemModel(
                            productId: widget.id,
                            productName: getProduct.name,
                            unitPrice: getProduct.oldPrice.toDouble(),
                            finalPrice: getProduct.newPrice.toDouble(),
                            discountPercentage: getProduct.discountPercentage,
                            quantity: 1,
                            subtotal: getProduct.newPrice.toDouble(),
                            productImage: getProduct.images[0].url,
                            isAvailable: getProduct.isAvailable,
                          ),
                        );
                      });

                      await CartService.addToCart(widget.id, 1);
                    }

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cart')),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
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
