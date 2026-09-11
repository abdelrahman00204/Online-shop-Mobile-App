import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/reviews_data.dart';
import 'package:the_project/widgets/star_rating.dart';

class BuildMyReviewsSection extends StatefulWidget {
  final Future<List<ReviewModel>> reviewsFuture;
  final VoidCallback
  onReviewChanged; // Callback to refresh when edited or deleted

  const BuildMyReviewsSection({
    required this.reviewsFuture,
    required this.onReviewChanged,
    super.key,
  });

  @override
  State<BuildMyReviewsSection> createState() => _BuildMyReviewsSectionState();
}

class _BuildMyReviewsSectionState extends State<BuildMyReviewsSection> {
  int _visibleReviewCount = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'profile.my_reviews'.tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<ReviewModel>>(
          future: widget.reviewsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('profile.reviews_error'.tr());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('profile.no_reviews'.tr());
            }

            final reviews = snapshot.data!;
            final displayedReviews = reviews.take(_visibleReviewCount).toList();

            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedReviews.length,
                  itemBuilder: (context, index) {
                    final review = displayedReviews[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    review.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF2E7D32),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (starIndex) => Icon(
                                      Icons.star,
                                      size: 16,
                                      color: starIndex < review.rating
                                          ? Colors.amber
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              review.comment,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review.createdAt.isNotEmpty
                                      ? review.createdAt.substring(0, 10)
                                      : '',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        _showEditReviewDialog(context, review);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await ReviewService.deleteReview(
                                          review.id,
                                        );
                                        widget.onReviewChanged();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                if (reviews.length > _visibleReviewCount)
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
              ],
            );
          },
        ),
      ],
    );
  }

  void _showEditReviewDialog(BuildContext context, ReviewModel review) {
    int updatedRating = review.rating
        .toInt(); // Safely convert to int for StarRating
    final TextEditingController commentController = TextEditingController(
      text: review.comment,
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Review'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StarRating(
                    rating: updatedRating,
                    onChanged: (newRating) {
                      setDialogState(() {
                        updatedRating = newRating;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Comment Input
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Update your review...',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                  onPressed: () async {
                    await ReviewService.updateReview(
                      reviewId: review.id,
                      rating: updatedRating.toDouble(),
                      comment: commentController.text,
                    );
                    if (context.mounted) Navigator.pop(context);
                    widget.onReviewChanged();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
