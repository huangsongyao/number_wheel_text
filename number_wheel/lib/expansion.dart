import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'calculate.dart';
import 'number_location.dart';

extension Scroll on ScrollController {
  void scrollTo(
    String number,
    double heights, {
    ValueChanged<String>? onCompleted,
  }) async {
    if (!hasClients) {
      return;
    }
    final dy = (double.tryParse(number) ?? 0.0) * heights;
    animateTo(
      dy,
      duration: wheelAnimationDuration,
      curve: Curves.easeIn,
    );
    Future.delayed(
      wheelAnimationDuration,
      () => onCompleted?.call(number),
    );
  }
}

extension Length on String {
  String replace() => replaceAll(',', '').replaceAll(' ', '');

  bool inequality(String str) {
    final replace = this.replace();
    final strReplace = str.replace();

    final length = (replace.contains('.')
        ? replace.split('.').first.length
        : replace.length);
    final strLength = (strReplace.contains('.')
        ? strReplace.split('.').first.length
        : strReplace.length);

    return (length != strLength);
  }

  String toFormat({
    int digit = 2,
    String? locale,
  }) {
    return NumberFormat.currency(
      decimalDigits: digit,
      locale: locale,
      symbol: '',
    ).format(_floor(digit).toInt());
  }

  Decimal _floor(int digit) {
    final str = (this.isEmpty ? '0' : this);
    final multiple = Decimal.fromInt(math.pow(10, digit).toInt());
    return (Decimal.parse(str) * multiple).floor() / multiple;
  }
}

extension Copy on List<NumberLocation> {
  void scrollsTo(
    String text,
    double heights, {
    ValueChanged<String>? onCompleted,
    bool useSeparator = false,
    int precision = 8,
    int integer = -1,
  }) {
    try {
      final numberStrings = MapNumber.numberStrings(
        text,
        precision: precision,
        useSeparator: useSeparator,
        integer: integer,
      );
      for (NumberLocation number in this) {
        final index = indexOf(number);
        if (index < numberStrings.length) {
          replaceRange(
            index,
            math.min((index + 1), length),
            [number.copyWith(numberStrings[index])],
          );
        }
      }
      for (NumberLocation number in this) {
        number.controller.scrollTo(
          number.number,
          heights,
        );
      }
      Future.delayed(
        wheelAnimationDuration,
        () => onCompleted?.call(text),
      );
    } catch (e) {
      print('${e.toString()}');
    }
  }
}
