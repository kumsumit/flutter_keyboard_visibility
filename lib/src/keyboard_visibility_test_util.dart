import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/src/keyboard_visibility_handler.dart';
import 'package:flutter_keyboard_visibility_platform_interface/flutter_keyboard_visibility_platform_interface.dart';

@visibleForTesting
class KeyboardVisibilityTesting {
  /// Forces this library to report a specific value for `isKeyboardVisible`
  /// for testing purposes.
  ///
  /// `KeyboardVisibility` will continue reporting `isKeyboardVisible`
  /// until the value is changed again with this method.
  @visibleForTesting
  static void setVisibilityForTesting(
    KeyboardVisibilityStatus isKeyboardVisible,
  ) {
    KeyboardVisibilityHandler.setVisibilityForTesting(isKeyboardVisible);
  }
}
