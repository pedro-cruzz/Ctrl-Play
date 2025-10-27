import 'package:flutter/material.dart';
import 'package:project/core/theme/app_colors.dart';

class StarRating extends StatefulWidget {
  final double initialRating; // nota inicial
  final int maxStars; // número máximo de estrelas
  final void Function(double)? onRatingChanged; // callback ao mudar a nota

  const StarRating({
    super.key,
    this.initialRating = 0,
    this.maxStars = 5,
    this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.maxStars, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = starIndex.toDouble();
            });
            if (widget.onRatingChanged != null) {
              widget.onRatingChanged!(_currentRating);
            }
          },
          child: Icon(
            starIndex <= _currentRating ? Icons.star : Icons.star_border,
            color: AppColors.starRating,
            size: 32,
          ),
        );
      }),
    );
  }
}
