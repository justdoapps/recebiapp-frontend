import 'dart:ui';

class Throttler {
  Throttler(this.interval);

  final Duration interval;
  DateTime? _lastRun;

  void run(VoidCallback action) {
    final now = DateTime.now();

    if (_lastRun == null || now.difference(_lastRun!) >= interval) {
      _lastRun = now;
      action();
    }
  }

  void cancel() {
    _lastRun = null;
  }
}

class AsyncThrottler {
  AsyncThrottler(this.interval);

  final Duration interval;
  DateTime? _lastRun;

  Future<void> run(Future<void> Function() action) async {
    final now = DateTime.now();

    if (_lastRun == null || now.difference(_lastRun!) >= interval) {
      _lastRun = now;
      await action();
    }
  }

  void cancel() {
    _lastRun = null;
  }
}
