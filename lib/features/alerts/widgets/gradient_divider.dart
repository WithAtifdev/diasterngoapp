import 'package:flutter/material.dart';

class GradientDivider extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry margin;

  const GradientDivider({
    super.key,
    this.height = 1,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white54,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}