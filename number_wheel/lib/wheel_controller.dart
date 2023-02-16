import 'package:flutter/material.dart';
import 'package:number_wheel/queue.dart';
import 'calculate.dart';

const TextStyle wheelStyle = TextStyle(
  color: Colors.deepPurpleAccent,
  fontWeight: FontWeight.bold,
  fontSize: 20.0,
);

class StyleController extends ChangeNotifier {
  TextStyle _richStyle;
  TextStyle _style;
  double _heights;

  StyleController({
    TextStyle? style,
    TextStyle? richStyle,
  })  : _heights = 0.0,
        _style = (style ?? wheelStyle),
        _richStyle = (richStyle ?? wheelStyle);

  TextStyle get style => _style;

  TextStyle get richStyle => _richStyle;

  void updateStyle(
    String text, {
    TextStyle? style,
    TextStyle? richStyle,
    bool notify = true,
  }) {
    _style = (style ?? _style);
    _richStyle = (richStyle ?? _richStyle);
    _heights = Calculated.calculate(
      text,
      _style,
    ).height;
    if (notify) {
      notifyListeners();
    }
  }

  double get heights => _heights;
}

class ValueController extends ChangeNotifier {
  String _value;
  bool _disposed = false;
  final TaskQueue _queue = TaskQueue();

  ValueController({
    String text = '0',
  }) : _value = text;

  @override
  void dispose() async {
    _disposed = true;
    await _queue.clean();
    super.dispose();
  }

  String get text => _value;

  bool get isDisposed => _disposed;

  set setText(String text) {
    if (_disposed) {
      return;
    }
    _queue
        .addTask(
            onFuture: (Task task) =>
                Future.delayed(wheelAnimationDuration, () => true))
        .then((value) {
      if (value.key) {
        try {
          _value = text;
          notifyListeners();
        } catch (e) {
          _disposed = true;
          _queue.clean();
        }
      }
    });
  }
}
