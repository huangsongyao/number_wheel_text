import 'dart:ui';

import 'package:flutter/material.dart';

const Duration wheelAnimationDuration = Duration(milliseconds: 300);

abstract class Calculated {
  static Size calculate(
    String text,
    TextStyle style, {
    int maxLines = 1,
    double maxWidth = double.infinity,
  }) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: style,
      ),
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);
    return painter.size;
  }
}
