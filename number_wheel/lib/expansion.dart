import 'dart:math';

import 'package:flutter/widgets.dart';

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
            min((index + 1), length),
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
      final current = DefaultCurrency().current;
      print('$current');
    }
  }
}
