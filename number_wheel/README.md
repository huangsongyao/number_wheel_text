# number_wheel

这个是一个支持千分位的数字跳动效果的text widget小部件，调用规则简单且易于定制。

远端仓库详见GitHub: https://github.com/huangsongyao/number_wheel_text

## Getting Started

这里通过外部返回一个StreamController来从外部控制内部实现数字跳动的动画效果，首次输入的值是否跳动也可以根据实际需要决定。

demo效果: https://user-images.githubusercontent.com/9814192/113866876-68b39480-97e0-11eb-95e6-09d672fbc564.mp4

example:

HSYNumberWheelText(
  text: '2323.43',
  mainAxisAlignment: MainAxisAlignment.center,
  onAnimation: (String old) {
    return _streamController;
  },
)

void _sendNext() {
  num next = (Random().nextInt(1000)).toDouble() +
        (Random().nextDouble().toDouble());
  _streamController.sink.add(next.toString());
}




