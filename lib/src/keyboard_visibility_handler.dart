import 'dart:async';

import 'package:flutter_keyboard_visibility_platform_interface/flutter_keyboard_visibility_platform_interface.dart';

/// Provides access to the current keyboard visibility state and emits
/// changes as they happen. For internal use only.
class KeyboardVisibilityHandler {
  KeyboardVisibilityHandler._();

  static FlutterKeyboardVisibilityPlatform get _platform =>
      FlutterKeyboardVisibilityPlatform.instance;

  static KeyboardVisibilityStatus _isInitialized =
      KeyboardVisibilityStatus.notVisible;
  static final _onChangeController =
      StreamController<KeyboardVisibilityStatus>();
  static final _onChange = _onChangeController.stream.asBroadcastStream();

  /// Emits true every time the keyboard is shown, and false every time the
  /// keyboard is dismissed.
  static Stream<KeyboardVisibilityStatus> get onChange {
    // If _testIsVisible set, don't try to create the EventChannel
    if (_isInitialized == KeyboardVisibilityStatus.notVisible &&
        _testIsVisible == null) {
      _platform.onChange.listen(_updateValue);
      _isInitialized = KeyboardVisibilityStatus.visible;
    }
    return _onChange;
  }

  /// Returns true if the keyboard is currently visible, false if not.
  static KeyboardVisibilityStatus get isVisible => _testIsVisible ?? _isVisible;
  static KeyboardVisibilityStatus _isVisible =
      KeyboardVisibilityStatus.notVisible;

  /// Fake representation of whether or not the keyboard is visible
  /// for testing purposes. When this value is non-null, it will be
  /// reported exclusively by the `isVisible` getter.
  static KeyboardVisibilityStatus? _testIsVisible;

  /// Forces `KeyboardVisibilityHandler` to report `isKeyboardVisible`
  /// for testing purposes.
  ///
  /// `KeyboardVisibilityHandler` will continue reporting `isKeyboardVisible`
  /// until the value is changed again with this method.
  static void setVisibilityForTesting(
    KeyboardVisibilityStatus isKeyboardVisible,
  ) {
    _updateValue(isKeyboardVisible);
  }

  static void _updateValue(KeyboardVisibilityStatus newValue) {
    _testIsVisible = newValue;

    // Don't report the same value multiple times
    if (newValue == _isVisible) {
      return;
    }

    _isVisible = newValue;
    _onChangeController.add(newValue);
  }
}
