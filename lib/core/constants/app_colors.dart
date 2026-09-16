import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background  = Color(0xFF0D0D0D);
  static const Color card        = Color(0xFF1A1A1A);
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color gold        = Color(0xFFc69c0c);

  // Risk colors
  static const Color extreme = Color(0xFFB71C1C); // dark red
  static const Color high    = Color(0xFFF44336); // red
  static const Color medium  = Color(0xFFFF9800); // orange
  static const Color low     = Color(0xFF4CAF50); // green

  // Disaster type colors
  static const Color earthquake = Color(0xFFBF360C); // deep orange
  static const Color flood      = Color(0xFF0D47A1); // deep blue
  static const Color storm      = Color(0xFF4A148C); // deep purple
  static const Color fire       = Color(0xFFE65100); // deep orange
}