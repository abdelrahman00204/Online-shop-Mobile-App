import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/reviews_data.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/widgets/star_rating.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard({
    super.key,
    required this.review,
    this.onReviewUpdated,
    this.onReviewDeleted,
  });

  final ReviewModel review;
  final VoidCallback? onReviewUpdated;
  final VoidCallback? onReviewDeleted;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    final bool isCurrentUser =
        AuthManage.instance.userId == widget.review.customerId;

    return Stack(
      children: [
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFE0E0E0),
                      child: Text(
                        widget.review.customerName.isNotEmpty
                            ? widget.review.customerName[0].toUpperCase()
                            : '?',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.review.customerName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.review.createdAt.isNotEmpty
                                ? widget.review.createdAt.split('T')[0]
                                : '',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < widget.review.rating
                              ? Color.fromARGB(255, 75, 165, 77)
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.review.comment,
                  style: TextStyle(color: Colors.grey[800]),
                ),
              ],
            ),
          ),
        ),
        if (isCurrentUser) ...[
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                  onPressed: () =>
                      _showEditReviewDialog(context, widget.review),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  onPressed: () async {
                    await ReviewService.deleteReview(widget.review.id);
                    if (widget.onReviewDeleted != null) {
                      widget.onReviewDeleted!();
                    }
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _showEditReviewDialog(BuildContext context, ReviewModel review) {
    int updatedRating = review.rating.toInt();
    final TextEditingController commentController = TextEditingController(
      text: review.comment,
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('item.edit_review'.tr()),
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
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'item.update_review_hint'.tr(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('item.cancel'.tr()),
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
                    if (widget.onReviewUpdated != null) {
                      widget.onReviewUpdated!();
                    }
                  },
                  child: Text('item.save'.tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
