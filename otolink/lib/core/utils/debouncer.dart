class Debouncer {
  Debouncer({required this.milliseconds});
  final int milliseconds;
  DateTime? _lastCall;
  bool get isReady {
    final now = DateTime.now();
    if (_lastCall == null) {
      _lastCall = now;
      return true;
    }
    final diff = now.difference(_lastCall!).inMilliseconds;
    if (diff >= milliseconds) {
      _lastCall = now;
      return true;
    }
    return false;
  }
}
