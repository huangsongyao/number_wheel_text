import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:number_wheel/expansion.dart';
import 'package:number_wheel/run_loop.dart';
import 'package:number_wheel/watch_consumer.dart';
import 'package:number_wheel/wheel_controller.dart';

import 'calculate.dart';
import 'number_location.dart';

class IdlerWheel extends ConsumerStatefulWidget {
  final Widget? action;
  final Widget? leading;
  final ValueController valueController;
  final MainAxisAlignment mainAxisAlignment;
  final RunLoopValueChanged? onChanged;
  final TextStyle? richStyle;
  final TextStyle? style;
  final bool useSeparator;
  final int precision;
  final int integer;
  final int rich;

  const IdlerWheel({
    Key? key,
    required this.valueController,
    this.richStyle,
    this.style,
    this.precision = 8,
    this.integer = -1,
    this.rich = 6,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.useSeparator = false,
    this.onChanged,
    this.leading,
    this.action,
  }) : super(key: key);

  @override
  _IdlerWheelState createState() => _IdlerWheelState();
}

class _IdlerWheelState extends ConsumerState<IdlerWheel> {
  late AutoDisposeChangeNotifierProvider<StyleController> _watchStyle;
  late AutoDisposeChangeNotifierProvider<_RepaintListener> _watchListener;
  late NumberRunLoop _runLoop;

  @override
  void initState() {
    super.initState();
    _runLoop = NumberRunLoop.run(onChanged: widget.onChanged);
    widget.valueController.addListener(_onValueChanged);
    _watchListener = AutoDisposeChangeNotifierProvider(
      (ref) => _RepaintListener(
        widget.valueController.text,
        useSeparator: widget.useSeparator,
        precision: widget.precision,
        integer: widget.integer,
        rich: widget.rich,
      ),
    );
    _watchStyle = AutoDisposeChangeNotifierProvider(
      (ref) => StyleController(
        style: widget.style,
        richStyle: widget.richStyle,
      ),
    );
    ref.read(_watchStyle).updateStyle(
          widget.valueController.text,
          style: ref.read(_watchStyle).style,
          richStyle: ref.read(_watchStyle).richStyle,
          notify: false,
        );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(_watchListener)._scrollTo(
            ref.read(_watchStyle).heights,
          );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _runLoop.closed();
  }

  @override
  Widget build(BuildContext context) {
    return WatchConsumer(
      watch: _watchListener.select((value) => value.numbers),
      builder:
          (BuildContext context, WidgetRef ref, List<NumberLocation> numbers) {
        return WatchConsumer(
          watch: _watchStyle.select<TextStyle>((value) => value.style),
          builder: (BuildContext context, WidgetRef ref, TextStyle style) {
            final isZero = ((Decimal.tryParse(widget.valueController.text) ??
                    Decimal.zero) ==
                Decimal.zero);
            return Row(
              mainAxisAlignment: widget.mainAxisAlignment,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (widget.leading ?? const SizedBox()),
                if (isZero)
                  Text(
                    '- -',
                    style: style,
                  ),
                if (!isZero)
                  ...numbers.map((number) {
                    if (number.isSymbol) {
                      return Text(
                        number.number,
                        style: style,
                      );
                    }
                    return SizedBox(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: number.controller,
                        child: Column(
                          children: number.numbers.map((loc) {
                            return Text(
                              loc,
                              style: (number.before
                                  ? style
                                  : ref.read(_watchStyle).richStyle),
                            );
                          }).toList(),
                        ),
                      ),
                      height: ref.read(_watchStyle).heights,
                    );
                  }).toList(),
                (widget.action ?? const SizedBox()),
              ],
            );
          },
        );
      },
    );
  }

  void _onValueChanged() {
    ref.read(_watchListener).updateRepaint(
          widget.valueController.text,
          ref.read(_watchStyle).heights,
        );
  }
}

class _RepaintListener extends ChangeNotifier {
  String _value;
  List<NumberLocation> _numbers;
  final bool _useSeparator;
  final int _precision;
  final int _integer;
  final int _rich;

  _RepaintListener(
    String value, {
    bool useSeparator = false,
    int precision = 8,
    int integer = -1,
    int rich = 6,
  })  : _value = value,
        _integer = integer,
        _precision = precision,
        _useSeparator = useSeparator,
        _numbers = MapNumber.numbers(
          value,
          precision: precision,
          useSeparator: useSeparator,
          integer: integer,
          rich: rich,
        ),
        _rich = rich;

  @override
  void dispose() {
    _deInit();
    super.dispose();
  }

  String get value => _value;

  Future<void> updateRepaint(
    String value,
    double heights,
  ) async {
    if (value
        .toFormat(
          digit: _precision,
        )
        .replace()
        .inequality(_value
            .toFormat(
              digit: _precision,
            )
            .replace())) {
      var hasScrolling = false;
      for (NumberLocation number in _numbers) {
        if (number.controller.hasClients) {
          if (number.controller.position.isScrollingNotifier.value) {
            hasScrolling = true;
            break;
          }
        }
      }
      if (hasScrolling) {
        await Future.delayed(wheelAnimationDuration);
      }
      _deInit();
      setNumbers = MapNumber.numbers(
        value,
        precision: _precision,
        useSeparator: _useSeparator,
        integer: _integer,
        rich: _rich,
      );
      await Future.delayed(wheelAnimationDuration);
    }
    _value = value;
    _scrollTo(heights);
  }

  List<NumberLocation> get numbers => _numbers;

  set setNumbers(List<NumberLocation> numbers) {
    _numbers = numbers;
    notifyListeners();
  }

  void _deInit() {
    for (NumberLocation number in _numbers) {
      number.controller.dispose();
    }
    _numbers = [];
  }

  void _scrollTo(double heights) {
    _numbers.scrollsTo(
      _value,
      heights,
      useSeparator: _useSeparator,
    );
  }
}
