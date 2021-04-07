import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:number_wheel_animation/number_formatter.dart';

typedef HSYNumberWheelAnimation = StreamController<String> Function(
    String oldText);

class HSYNumberWheelText extends StatefulWidget {
  /// 纯数字文本
  final String text;

  /// 文本的风格
  final TextStyle textStyle;

  /// 金额的小数点后位数，默认为小数点后两位
  final int decimals;

  /// 是否需要千分位，默认需要
  final bool showThousands;

  /// 单个数字的高度，默认为35.0
  final num textHeights;

  /// 动画时间，默认为0.5s
  final Duration duration;

  /// 对其方式，默认左对齐
  final MainAxisAlignment mainAxisAlignment;

  /// 每次需要执行外部刷新时，通过返回一个Stream来发送动画信息
  final HSYNumberWheelAnimation onAnimation;

  HSYNumberWheelText({
    @required this.text,
    @required this.onAnimation,
    this.duration = const Duration(milliseconds: 500),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.showThousands = true,
    this.textHeights = 35.0,
    this.decimals = 2,
    this.textStyle,
  });

  @override
  _HSYNumberWheelTextState createState() => _HSYNumberWheelTextState();
}

class _HSYNumberWheelTextState extends State<HSYNumberWheelText> {
  ///
  List<dynamic> _textNumbers = [];
  String _liveText;

  /// 0-9直接的数字
  List<String> get _numbers {
    return [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
    ];
  }

  /// 将数字文本解析成对应的数据
  List<dynamic> get _toMapDataNumbers {
    final List<dynamic> textNumbers = [];
    final String realText = (this.widget.showThousands
        ? NumberFormatter.thousandSeparatorFormatterStr(
            _liveText,
            decimals: this.widget.decimals,
          )
        : _liveText);
    for (int i = 0; i < realText.length; i++) {
      dynamic text = realText[i];
      final bool isNumber = _numbers.contains(text);
      if (isNumber) {
        text = {
          ScrollController(): {
            _numbers.firstWhere((element) {
              return (Decimal.tryParse(element) == Decimal.tryParse(text));
            }): _numbers
          },
        };
      }
      textNumbers.add(text);
    }
    return textNumbers;
  }

  /// 数字文本的风格
  TextStyle get _textStyle {
    return (this.widget.textStyle ??
        TextStyle(
          fontSize: 30.0,
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ));
  }

  /// 获取纯数字集合的数据
  Map<ScrollController, Map<String, List>> get _dataBeats {
    final Map<ScrollController, Map<String, List>> dataBeats =
        <ScrollController, Map<String, List>>{};
    _textNumbers.forEach((element) {
      if (_isMapElement(element)) {
        final Map<ScrollController, Map<String, List>> toMaps =
            element as Map<ScrollController, Map<String, List>>;
        dataBeats[toMaps.keys.first] = toMaps.values.first;
      }
    });
    return dataBeats;
  }

  /// 文本的高度
  double get _textHeights {
    return (this.widget.textHeights ?? 35.0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _liveText = Decimal.tryParse((this.widget.text ?? '0')).toString();
    _textNumbers = _toMapDataNumbers;
    this.widget.onAnimation(_liveText).stream.listen((news) {
      _liveText = Decimal.tryParse((news ?? '0')).toString();
      setState(() {
        Future.delayed(
          Duration(milliseconds: 350),
          () {
            _animatedTo();
          },
        );
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dataBeats.forEach((key, value) {
      key.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    _textNumbers = _toMapDataNumbers;
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: this.widget.mainAxisAlignment,
        children: _textNumbers.map((text) {
          if (_isMapElement(text)) {
            final Map<ScrollController, Map<String, List>> toMaps =
                text as Map<ScrollController, Map<String, List>>;
            final ScrollController scrollController = toMaps.keys.first;
            return Container(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                controller: scrollController,
                child: Column(
                  children: toMaps.values.first.values.first.map((number) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(
                        number,
                        style: _textStyle,
                      ),
                    );
                  }).toList(),
                ),
              ),
              height: _textHeights,
            );
          }
          return Container(
            child: Text(
              text,
              style: _textStyle,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _animatedTo() {
    _dataBeats.forEach((key, value) {
      final ScrollController scrollController = key;
      scrollController.animateTo(
        (Decimal.tryParse(value.keys.first) *
                Decimal.tryParse(_textHeights.toString()))
            .toDouble(),
        duration: this.widget.duration,
        curve: Curves.easeIn,
      );
    });
  }

  bool _isMapElement(dynamic element) {
    return (element is Map);
  }
}
