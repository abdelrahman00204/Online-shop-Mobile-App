import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/cart_data.dart';
import 'package:the_project/data/product_data.dart';
import 'package:the_project/data/reviews_data.dart';
import 'package:the_project/data/wish_list_data.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/screens/cart_screen.dart';
import 'package:the_project/screens/wishlist_screen.dart';
import 'package:the_project/widgets/quantity_stepper.dart';
import 'package:the_project/widgets/review_card.dart';
import 'package:the_project/widgets/star_rating.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key, required this.id});
  final int id;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  int _quantity = 1;
  bool _isCartLoading = false;
  bool _isWishlistLoading = false;
  bool _isReviewLoading = false;
  bool _isReviewSubmitting = false;

  int _visibleReviewCount = 1;

  int _userRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  final GlobalKey<FormState> _reviewFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getReviews();
  }

  void getReviews() async {
    try {
      setState(() => _isReviewLoading = true);
      await ReviewService.getProductReviews(widget.id);
      if (mounted) {
        setState(() {
          _isReviewLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isProductInWishlist = wishlist.any(
      (item) => item.productId == widget.id,
    );
    final product = products.firstWhere((item) => item.id == widget.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(product.images[0].url),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: _isWishlistLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: Icon(
                              isProductInWishlist
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isProductInWishlist
                                  ? Colors.green
                                  : Colors.black,
                            ),
                            onPressed: () async {
                              setState(() => _isWishlistLoading = true);
                              try {
                                if (isProductInWishlist) {
                                  await deleteFromWishlist(widget.id);
                                } else {
                                  await addToWishlist(widget.id);
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _isWishlistLoading = false);
                                }
                              }
                            },
                          ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 75, 165, 77),
                        size: 24,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.averageRating}) ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${product.reviewsCount}) ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'EGP ${product.newPrice}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (product.discountPercentage != null)
                        Text(
                          'EGP ${product.oldPrice}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('${'item.availability_label'.tr()} '),
                          Text(
                            product.isAvailable
                                ? 'item.in_stock'.tr()
                                : 'item.not_available'.tr(),
                            style: TextStyle(
                              color: product.isAvailable
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('${'item.unit_label'.tr(args: [''])} '),
                          Text(
                            product.unitType,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'item.description_label'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description ?? 'item.no_description'.tr(),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      QuantityStepper(
                        quantity: _quantity,
                        productId: widget.id,
                        onChanged: (newQuantity) =>
                            setState(() => _quantity = newQuantity),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isProductInWishlist
                                ? Colors.grey[200]
                                : const Color(0xFF2E7D32),
                            foregroundColor: isProductInWishlist
                                ? Colors.black
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _isWishlistLoading
                              ? null
                              : () async {
                                  if (isProductInWishlist) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const WishlistScreen(),
                                      ),
                                    );
                                  } else {
                                    setState(() => _isWishlistLoading = true);
                                    try {
                                      await addToWishlist(product.id);
                                    } finally {
                                      if (mounted) {
                                        setState(
                                          () => _isWishlistLoading = false,
                                        );
                                      }
                                    }
                                  }
                                },
                          icon: _isWishlistLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.favorite),
                          label: Text(
                            isProductInWishlist
                                ? 'item.go_to_wishlist'.tr()
                                : 'item.add_to_wishlist'.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isCartLoading
                          ? null
                          : () async {
                              setState(() => _isCartLoading = true);
                              try {
                                final existingIndex = cartdata.indexWhere(
                                  (item) => item.productId == widget.id,
                                );

                                if (existingIndex != -1) {
                                  cartdata[existingIndex].quantity += _quantity;
                                  await CartService.updateCartQuantity(
                                    widget.id,
                                    cartdata[existingIndex].quantity,
                                  );
                                } else {
                                  cartdata.add(
                                    CartItemModel(
                                      productId: widget.id,
                                      productName: product.name,
                                      unitPrice: product.oldPrice.toDouble(),
                                      finalPrice: product.newPrice.toDouble(),
                                      discountPercentage:
                                          product.discountPercentage,
                                      quantity: _quantity,
                                      subtotal:
                                          product.newPrice.toDouble() *
                                          _quantity,
                                      productImage: product.images[0].url,
                                      isAvailable: product.isAvailable,
                                    ),
                                  );
                                  await CartService.addToCart(
                                    widget.id,
                                    _quantity,
                                  );
                                }

                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to cart'),
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() => _isCartLoading = false);
                                }
                              }
                            },
                      icon: _isCartLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.shopping_cart),
                      label: Text('item.add_to_cart'.tr()),
                    ),
                  ),
                  const Divider(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'item.customer_reviews'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _isReviewLoading
                      ? const Center(child: CircularProgressIndicator())
                      : productReviewsData.isEmpty
                      ? Center(
                          child: Text(
                            'item.no_reviews'
                                .tr(), // Optional: show empty state message
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              productReviewsData.length < _visibleReviewCount
                              ? productReviewsData.length
                              : _visibleReviewCount,
                          itemBuilder: (context, index) {
                            return ReviewCard(
                              review: productReviewsData[index],
                              onReviewDeleted: () {
                                getReviews();
                                ReviewService.getMyReviews();
                                setState(() {});
                              },
                              onReviewUpdated: () {
                                getReviews();
                                setState(() {});
                              },
                            );
                          },
                        ),
                  const SizedBox(height: 12),

                  // Show button only if there are more reviews left to display
                  if (!_isReviewLoading &&
                      productReviewsData.length > _visibleReviewCount)
                    Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _visibleReviewCount += 3;
                          });
                        },
                        child: Text('item.view_more_reviews'.tr()),
                      ),
                    ),
                  if (!myReviewsData.any(
                        (review) => review.productId == product.id,
                      ) &&
                      AuthManage.instance.isLoggedIn) ...[
                    const Divider(height: 40),
                    Text(
                      'item.add_your_review'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _reviewFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('item.your_rating'.tr()),
                              const SizedBox(height: 8),
                              StarRating(
                                rating: _userRating,
                                onChanged: (rating) {
                                  setState(() => _userRating = rating);
                                },
                              ),
                              const SizedBox(height: 16),
                              Text('item.your_comment'.tr()),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _reviewController,
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: 'item.comment_hint'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'item.comment_required'.tr();
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: _isReviewSubmitting
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2E7D32),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (!_reviewFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }
                                    setState(() {
                                      _isReviewSubmitting = true;
                                    });
                                    await ReviewService.createReview(
                                      productId: widget.id,
                                      rating: _userRating.toDouble(),
                                      comment: _reviewController.text,
                                    );

                                    getReviews();
                                    ReviewService.getMyReviews();
                                    debugPrint(
                                      productReviewsData
                                          .map((r) => r.customerId)
                                          .toList()
                                          .toString(),
                                    );
                                    debugPrint(
                                      AuthManage.instance.userId.toString(),
                                    );
                                    setState(() {
                                      _isReviewSubmitting = false;
                                    });
                                  },
                                  label: Text('item.submit_review'.tr()),
                                ),
                              ),
                            ],
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
