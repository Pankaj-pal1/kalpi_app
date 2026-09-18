import 'package:flutter/foundation.dart';

/// A one-shot switch that makes the next write operation fail.
///
/// Exists purely so the save/delete recovery flows can be demonstrated
/// without a network. Session-scoped; never persisted.
class DemoFailureSwitch extends ChangeNotifier {
  bool _armed = false;

  bool get isArmed => _armed;

  void arm(bool value) {
    if (_armed == value) return;
    _armed = value;
    notifyListeners();
  }

  /// Returns true once when armed, then disarms itself.
  bool consume() {
    if (!_armed) return false;
    _armed = false;
    notifyListeners();
    return true;
  }
}
