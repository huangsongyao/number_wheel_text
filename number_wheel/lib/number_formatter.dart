import 'package:intl/intl.dart';

class NumberFormatter {
  static double rounds(
    num amount, {
    int decimals = 2,
  }) {
    if (amount == null) {
      amount = 0;
    }
    String amountStr = amount.toString().toLowerCase();
    if (amountStr.indexOf('e') >= 0) {
      amountStr = amount.toDouble().toStringAsFixed(8);
    }
    int index = amountStr.indexOf('.');
    if (index != -1) {
      int last = (index + decimals + 1);
      if (last > amountStr.length) {
        last = amountStr.length;
      }
      return num.tryParse(
        amountStr.substring(0, last),
      ).toDouble();
    }

    return amount.toDouble();
  }

  static String thousandSeparatorFormatter(
    num amount, {
    int decimals = 2,
    String delimiter = ',',
  }) {
    return NumberFormat.currency(
      decimalDigits: decimals,
      customPattern: '###$delimiter###.#',
    ).format(NumberFormatter.rounds(
      amount,
      decimals: decimals,
    ));
  }

  static String thousandSeparatorFormatterStr(
    String amount, {
    int decimals = 2,
    String delimiter = ',',
  }) {
    return NumberFormat.currency(
      decimalDigits: decimals,
      customPattern: '###$delimiter###.#',
    ).format(decimals != null
        ? NumberFormatter.rounds(
            double.tryParse(amount),
            decimals: decimals,
          )
        : num.tryParse(amount));
  }
}
