# number_wheel_text插件
一个flutter-动画text-widge，效果如下：
![Watch the vide](https://user-images.githubusercontent.com/9814192/113866876-68b39480-97e0-11eb-95e6-09d672fbc564.mp4)

# 使用方式
//外部控制动画，这里需要返回一个流控制器，在有需要的地方，通过流控制器给部件内部发送消息，从而执行动画
```
HSYNumberWheelText(
    text: '2323.43',
    mainAxisAlignment: MainAxisAlignment.center,
    onAnimation: (String old) {
        return _streamController;
    },
),

```
``` 

void _sendNext() {
    num next = (Random().nextInt(1000)).toDouble() +
        (Random().nextDouble().toDouble());
    _streamController.sink.add(next.toString());
}


```
