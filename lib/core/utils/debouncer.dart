import 'dart:async';
import 'dart:ui';

class Debouncer {
  Debouncer(this.delay);

  final Duration delay;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }
}

class AsyncDebouncer {
  AsyncDebouncer(this.delay);

  final Duration delay;
  Timer? _timer;

  void run(Future<void> Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, () async {
      await action();
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
