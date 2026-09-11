import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int rating; // 0-5
  final ValueChanged<int> onChanged;

  const StarRating({super.key, required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          GestureDetector(
            onTap: () => onChanged(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.star,
                size: 40,
                color: i <= rating
                    ? Color.fromARGB(255, 75, 165, 77)
                    : Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}
