# number_wheel

这个是一个支持千分位的数字跳动效果的text widget小部件，调用规则简单且易于定制。

0.1.2版本更新
    - 支持null safety
    - 支持自定义整数和小数两部分的精度
    - 小数部分精度支持富文本格式
    - 支持多线程访问安全

远端仓库详见GitHub: https://github.com/huangsongyao/number_wheel_text

## Getting Started

这里通过外部返回一个Controller来从外部控制内部实现数字跳动的动画效果，首次输入的值是否跳动也可以根据实际需要决定。

# example:

``` 

IdlerWheel(
valueController: _controller,
useSeparator: true,
)

```


