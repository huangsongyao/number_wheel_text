import 'package:flutter/material.dart';
import 'package:number_wheel/expansion.dart';

abstract class NumberSymbol {
  static String get zeroNumber => '0';

  static String get pointNumber => '.';

  static String get separatorNumber => ',';
}

class NumberLocation {
  final List<String> numbers;
  final ScrollController controller;
  final String number;
  final bool isSymbol;
  final bool before; // 小数点前

  NumberLocation(
    this.number, {
    this.before = true,
    this.numbers = const ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    this.isSymbol = false,
    ScrollController? controller,
  }) : controller = (controller ?? ScrollController());

  factory NumberLocation.zero() => NumberLocation(NumberSymbol.zeroNumber);

  factory NumberLocation.point() =>
      NumberLocation(NumberSymbol.pointNumber, isSymbol: true);

  factory NumberLocation.separator() =>
      NumberLocation(NumberSymbol.separatorNumber, isSymbol: true);

  NumberLocation copyWith(
    String number, {
    bool? before,
  }) =>
      NumberLocation(
        number,
        numbers: numbers,
        isSymbol: [
          NumberSymbol.pointNumber,
          NumberSymbol.separatorNumber,
        ].contains(number),
        controller: controller,
        before: (before ?? this.before),
      );
}

abstract class MapNumber {
  static List<String> numberStrings(
    String text, {
    int precision = 8,
    bool useSeparator = false,
    int integer = -1,
  }) {
    final replace = text.replace();
    if (replace.contains(NumberSymbol.pointNumber)) {
      final splits = replace.split(NumberSymbol.pointNumber);
      var intString = splits.first;
      while (intString.length < integer) {
        intString = '${NumberSymbol.zeroNumber}$intString';
      }
      if (useSeparator) {
        intString = intString.toCurrency(digit: 0);
      }
      final numbers = List.generate(
        intString.length,
        (index) => intString[index].toString(),
      );
      numbers.add(NumberSymbol.pointNumber);
      numbers.addAll(
        List.generate(precision, (index) {
          if (index >= splits.last.length) {
            return NumberSymbol.zeroNumber;
          }
          return splits.last[index].toString();
        }),
      );
      return numbers;
    }
    var intString = replace;
    if (useSeparator) {
      intString = intString.toCurrency(digit: 0);
    }
    final integers = List.generate(
      intString.length,
      (index) => intString[index].toString(),
    )..add(NumberSymbol.pointNumber);
    return integers
      ..addAll(
        List.generate(precision, (index) => NumberSymbol.zeroNumber),
      );
  }

  static List<NumberLocation> numbers(
    String text, {
    int rich = 6,
    int precision = 8,
    bool useSeparator = false,
    int integer = -1,
  }) {
    final List<NumberLocation> locations = numberStrings(
      text,
      precision: precision,
      useSeparator: useSeparator,
      integer: integer,
    ).map((number) {
      return (number == NumberSymbol.pointNumber
          ? NumberLocation.point()
          : (number == NumberSymbol.separatorNumber
              ? NumberLocation.separator()
              : (number == NumberSymbol.zeroNumber
                  ? NumberLocation.zero()
                  : NumberLocation(number))));
    }).toList();
    return locations.map((location) {
      final index = locations.indexOf(location);
      final before = (rich <= 0 ? true : (locations.length - index > rich));
      return location.copyWith(
        location.number,
        before: before,
      );
    }).toList();
  }
}
