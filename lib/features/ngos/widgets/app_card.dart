import 'package:flutter/material.dart';


class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.margin,
    this.color,
    this.width, this.height,
  });

  static const Color _defaultCard = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width / 1.2,
      height: height ?? MediaQuery.of(context).size.height / 1.9,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? _defaultCard,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }
}