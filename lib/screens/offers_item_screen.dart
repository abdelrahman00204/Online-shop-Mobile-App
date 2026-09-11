import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_project/data/cart_data.dart';
import 'package:the_project/data/offers_data.dart';
import 'package:the_project/screens/item_screen.dart';
import 'package:the_project/widgets/checkout_dialog.dart';
import 'package:transparent_image/transparent_image.dart';

class OfferItemScreen extends StatefulWidget {
  const OfferItemScreen({super.key, required this.offer});
  final OfferModel offer;

  @override
  State<OfferItemScreen> createState() => _OfferItemScreenState();
}

class _OfferItemScreenState extends State<OfferItemScreen> {
  int _currentPage = 0;
  bool _isCartLoading = false;

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      widget.offer.imageUrl,
      ...widget.offer.products.map((p) => p.productImage),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.offer.title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // PageView for Offer Image and Product Images
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: imageUrls.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        placeholder: (context, url) =>
                            Image.memory(kTransparentImage),
                        imageUrl: imageUrls[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        imageUrls.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? const Color(0xFF2E7D32)
                                : Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.offer.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.offer.description,
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'EGP ${widget.offer.totalOfferPrice}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (widget.offer.discountPercentage != null &&
                          widget.offer.discountPercentage != 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${widget.offer.discountPercentage}% OFF',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Divider(height: 32),
                  const Text(
                    'Products Included in this Offer:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.offer.products.length,
                    itemBuilder: (context, index) {
                      final product = widget.offer.products[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ItemScreen(id: product.productId),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: product.productImage,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.image,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Quantity: ${product.quantity}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (widget.offer.discountPercentage !=
                                            null &&
                                        widget.offer.discountPercentage !=
                                            0) ...[
                                      Text(
                                        'EGP ${product.finalPrice}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),

                                      IconButton.filled(
                                        style: IconButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF2E7D32,
                                          ),
                                          foregroundColor: Colors.white,
                                        ),
                                        tooltip: 'item.add_to_cart'.tr(),
                                        onPressed: _isCartLoading
                                            ? null
                                            : () async {
                                                setState(
                                                  () => _isCartLoading = true,
                                                );
                                                try {
                                                  final existingIndex = cartdata
                                                      .indexWhere(
                                                        (item) =>
                                                            item.productId ==
                                                            product.productId,
                                                      );

                                                  if (existingIndex != -1) {
                                                    cartdata[existingIndex]
                                                            .quantity +=
                                                        product.quantity;
                                                    await CartService.updateCartQuantity(
                                                      product.productId,
                                                      cartdata[existingIndex]
                                                          .quantity,
                                                    );
                                                  } else {
                                                    cartdata.add(
                                                      CartItemModel(
                                                        productId:
                                                            product.productId,
                                                        productName:
                                                            product.productName,
                                                        unitPrice: product
                                                            .originalPrice,
                                                        finalPrice:
                                                            product.finalPrice,
                                                        discountPercentage:
                                                            widget
                                                                .offer
                                                                .discountPercentage ??
                                                            0.0,
                                                        quantity:
                                                            product.quantity,
                                                        subtotal:
                                                            product.finalPrice *
                                                            product.quantity,
                                                        productImage: product
                                                            .productImage,
                                                        isAvailable: true,
                                                      ),
                                                    );
                                                    await CartService.addToCart(
                                                      product.productId,
                                                      product.quantity,
                                                    );
                                                  }

                                                  if (!mounted) return;
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Added to cart',
                                                      ),
                                                    ),
                                                  );
                                                } finally {
                                                  if (mounted) {
                                                    setState(
                                                      () => _isCartLoading =
                                                          false,
                                                    );
                                                  }
                                                }
                                              },
                                        icon: _isCartLoading
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : const Icon(
                                                Icons.add_shopping_cart,
                                                size: 20,
                                              ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  if (widget.offer.discountPercentage == null ||
                      widget.offer.discountPercentage == 0) ...[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          showCheckoutDialog(
                            context,
                            offerId: widget.offer.id,
                            amountToPay: widget.offer.totalOfferPrice,
                          );
                        },
                        child: Text(
                          'common.buy_now'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
