import 'package:flutter/material.dart';

class Responsive {
  static double horizontalPadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width > 1000) return width * 0.2;
    if (width > 600) return width * 0.1;
    return width * 0.08;
  }
}
