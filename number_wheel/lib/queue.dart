import 'dart:async';
import 'dart:collection';

typedef TaskResponse = void Function(bool success, dynamic response);
typedef TaskFuture = Future<dynamic> Function(Task task);

class Task {
  final TaskResponse onResponse;
  final TaskFuture onFuture;

  Task({
    required this.onResponse,
    required this.onFuture,
  });
}

class TaskQueue {
  final Queue<Task> _queue = Queue<Task>();
  bool _taskRunning = false;

  bool get taskRunning => _taskRunning;

  Future<void> clean() async {
    if (_queue.isEmpty) return;
    _taskRunning = true;
    _queue.clear();
    _taskRunning = false;
  }

  Future<MapEntry<bool, dynamic>> addTask({
    required TaskFuture onFuture,
    Map<String, dynamic> param = const <String, dynamic>{},
  }) {
    final completer = Completer<MapEntry<bool, dynamic>>();
    final task = Task(
      onResponse: (bool success, dynamic response) {
        if (success) {
          completer.complete(MapEntry(success, response));
        } else {
          completer.completeError(response);
        }
      },
      onFuture: onFuture,
    );
    _queue.add(task);
    _runTask();
    return completer.future;
  }

  Future<void> _runTask() async {
    if (_queue.isEmpty) return;
    if (_taskRunning) return;

    _taskRunning = true;
    final task = _queue.removeFirst();
    try {
      final completed = (await task.onFuture(task));
      if (completed != null) {
        task.onResponse(
          true,
          completed,
        );
      }
    } catch (e) {
      task.onResponse(false, e);
    }
    _taskRunning = false;
    _runTask();
  }
}
