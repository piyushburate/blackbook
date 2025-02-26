import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TitlePlaceholder extends StatelessWidget {
  const TitlePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 12.0,
      color: Colors.grey.shade100,
    ).animate().shimmer();
  }
}
