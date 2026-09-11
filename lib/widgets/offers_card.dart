import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_project/data/offers_data.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback? onTap;

  const OfferCard({super.key, required this.offer, this.onTap});

  @override
  Widget build(BuildContext context) {
    final previewImages = offer.products
        .map((p) => p.productImage)
        .take(2)
        .toList();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                offer.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00B251),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                offer.description,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 2; i++)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 95,
                        height: 75,
                        color: Colors.grey.shade100,
                        child: i < previewImages.length
                            ? CachedNetworkImage(
                                imageUrl: previewImages[i],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.broken_image,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                              )
                            : CachedNetworkImage(
                                imageUrl: offer.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.broken_image,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                              ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (offer.discountPercentage != null &&
                      offer.discountPercentage != 0) ...{
                    Text(
                      'Discount: ${offer.discountPercentage}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  },
                  Text(
                    'Total: EGP ${offer.totalOfferPrice}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00B251),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
