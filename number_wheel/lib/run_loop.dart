import 'dart:async';

typedef RunLoopValueChanged = Future<bool> Function(Timer timer);

class NumberRunLoop {
  final int seconds;
  final RunLoopValueChanged? onChanged;

  Timer? _timer;
  bool _hangUp = false;

  NumberRunLoop({
    this.seconds = 1,
    this.onChanged,
  });

  factory NumberRunLoop.run({
    int seconds = 1,
    bool running = true,
    RunLoopValueChanged? onChanged,
  }) {
    final NumberRunLoop runLoop = NumberRunLoop(
      seconds: seconds,
      onChanged: onChanged,
    );
    if (running) {
      runLoop.start();
    }
    return runLoop;
  }

  void start() {
    _runLoop();
  }

  void pause({
    bool hangUp = true,
  }) {
    _hangUp = hangUp;
  }

  void cancel() {
    _timer?.cancel();
  }

  void closed() {
    pause();
    cancel();
  }

  void _runLoop() {
    cancel();
    _timer ??= Timer.periodic(Duration(seconds: seconds), (timer) async {
      if (!_hangUp) {
        final stop = (await onChanged?.call(timer) ?? false);
        if (stop) {
          cancel();
        }
      }
    });
  }
}
