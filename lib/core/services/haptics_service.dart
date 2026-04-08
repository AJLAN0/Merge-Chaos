import 'package:flutter/services.dart';

class HapticsService {
  bool _enabled = true;

  bool get enabled => _enabled;

  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  void lightTap() {
    if (!_enabled) return;
    HapticFeedback.lightImpact();
  }

  void mediumImpact() {
    if (!_enabled) return;
    HapticFeedback.mediumImpact();
  }

  void heavyImpact() {
    if (!_enabled) return;
    HapticFeedback.heavyImpact();
  }

  void selectionClick() {
    if (!_enabled) return;
    HapticFeedback.selectionClick();
  }
}
