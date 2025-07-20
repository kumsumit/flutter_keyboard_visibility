import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'flutter_keyboard_visibility_test.mocks.dart';

@GenerateMocks([KeyboardVisibilityController])
void main() {
  group('KeyboardVisibilityProvider', () {
    testWidgets('It reports true when the keyboard is visible', (
      WidgetTester tester,
    ) async {
      // Pretend that the keyboard is visible.
      var mockController = MockKeyboardVisibilityController();
      when(mockController.onChange).thenAnswer(
        (_) => Stream.fromIterable([KeyboardVisibilityStatus.visible]),
      );
      when(
        mockController.isVisible,
      ).thenAnswer((_) => KeyboardVisibilityStatus.visible);

      // Build a Widget tree and query KeyboardVisibilityProvider
      // for the visibility of the keyboard.
      KeyboardVisibilityStatus isKeyboardVisible =
          KeyboardVisibilityStatus.notVisible;

      await tester.pumpWidget(
        KeyboardVisibilityProvider(
          controller: mockController,
          child: Builder(
            builder: (BuildContext context) {
              isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(
                context,
              );
              return SizedBox();
            },
          ),
        ),
      );

      // Verify that KeyboardVisibilityProvider reported that the
      // keyboard is visible.
      expect(isKeyboardVisible, KeyboardVisibilityStatus.visible);
    });

    testWidgets('It reports false when the keyboard is NOT visible', (
      WidgetTester tester,
    ) async {
      // Pretend that the keyboard is hidden.
      var mockController = MockKeyboardVisibilityController();
      when(mockController.onChange).thenAnswer(
        (_) => Stream.fromIterable([KeyboardVisibilityStatus.notVisible]),
      );
      when(
        mockController.isVisible,
      ).thenAnswer((_) => KeyboardVisibilityStatus.notVisible);

      // Build a Widget tree and query KeyboardVisibilityProvider
      // for the visibility of the keyboard.
      KeyboardVisibilityStatus isKeyboardVisible =
          KeyboardVisibilityStatus.visible;

      await tester.pumpWidget(
        KeyboardVisibilityProvider(
          controller: mockController,
          child: Builder(
            builder: (BuildContext context) {
              isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(
                context,
              );
              return SizedBox();
            },
          ),
        ),
      );

      // Verify that KeyboardVisibilityProvider reported that the
      // keyboard is visible.
      expect(isKeyboardVisible, KeyboardVisibilityStatus.notVisible);
    });

    testWidgets('It rebuilds when the keyboard visibility changes', (
      WidgetTester tester,
    ) async {
      // Pretend that the keyboard is visible.
      var mockController = MockKeyboardVisibilityController();
      var streamController = StreamController<KeyboardVisibilityStatus>();
      streamController.add(KeyboardVisibilityStatus.visible);
      when(mockController.onChange).thenAnswer((_) => streamController.stream);
      when(
        mockController.isVisible,
      ).thenAnswer((_) => KeyboardVisibilityStatus.visible);

      // Build a Widget tree with a KeyboardVisibilityProvider.
      KeyboardVisibilityStatus? isKeyboardVisible;

      await tester.pumpWidget(
        KeyboardVisibilityProvider(
          controller: mockController,
          child: Builder(
            builder: (BuildContext context) {
              isKeyboardVisible = KeyboardVisibilityProvider.isKeyboardVisible(
                context,
              );
              return SizedBox();
            },
          ),
        ),
      );

      // We expect that the keyboard is initially reported as visible.
      expect(isKeyboardVisible, KeyboardVisibilityStatus.visible);

      // Pretend that the keyboard has gone from visible to hidden.
      streamController.add(KeyboardVisibilityStatus.notVisible);
      when(
        mockController.isVisible,
      ).thenAnswer((_) => KeyboardVisibilityStatus.notVisible);

      // Pump the tree to allow the InheritedWidget dependency to
      // rebuild its descendants.
      await tester.pumpAndSettle();

      // Verify that our descendant rebuilt itself, and received the
      // updated visibility of the keyboard.
      expect(isKeyboardVisible, false);
    });
  });

  group('KeyboardVisibilityBuilder', () {
    testWidgets('It reports true when the keyboard is visible', (
      WidgetTester tester,
    ) async {
      // Pretend that the keyboard is visible.
      var mockController = MockKeyboardVisibilityController();
      when(mockController.onChange).thenAnswer(
        (_) => Stream.fromIterable([KeyboardVisibilityStatus.visible]),
      );
      when(
        mockController.isVisible,
      ).thenAnswer((_) => KeyboardVisibilityStatus.visible);

      // Build a Widget tree and query KeyboardVisibilityBuilder
      // for the visibility of the keyboard.
      KeyboardVisibilityStatus? isKeyboardVisible;

      await tester.pumpWidget(
        KeyboardVisibilityBuilder(
          controller: mockController,
          builder: (_, _isKeyboardVisible) {
            isKeyboardVisible = _isKeyboardVisible;
            return SizedBox();
          },
        ),
      );

      // Verify that KeyboardVisibilityBuilder reported that the
      // keyboard is visible.
      expect(isKeyboardVisible, true);
    });

    testWidgets('It reports false when the keyboard is NOT visible', (
      WidgetTester tester,
    ) async {
      // Pretend that the keyboard is hidden.
      var mockController = MockKeyboardVisibilityController();
      when(mockController.onChange).thenAnswer(
        (_) => Stream.fromIterable([KeyboardVisibilityStatus.notVisible]),
      );
      when(
        mockController.isVisible,
      ).thenAnswer((_) => KeyboardVisibilityStatus.notVisible);

      // Build a Widget tree and query KeyboardVisibilityBuilder
      // for the visibility of the keyboard.
      KeyboardVisibilityStatus? isKeyboardVisible;

      await tester.pumpWidget(
        KeyboardVisibilityBuilder(
          controller: mockController,
          builder: (_, _isKeyboardVisible) {
            isKeyboardVisible = _isKeyboardVisible;
            return SizedBox();
          },
        ),
      );

      // Verify that KeyboardVisibilityBuilder reported that the
      // keyboard is visible.
      expect(isKeyboardVisible, KeyboardVisibilityStatus.notVisible);
    });

    testWidgets('It rebuilds when the keyboard visibility changes', (
      WidgetTester tester,
    ) async {
      // Pretend that the keyboard is visible.
      var mockController = MockKeyboardVisibilityController();
      var streamController = StreamController<KeyboardVisibilityStatus>();
      streamController.add(KeyboardVisibilityStatus.visible);
      when(mockController.onChange).thenAnswer((_) => streamController.stream);
      when(
        mockController.isVisible,
      ).thenAnswer((_) => KeyboardVisibilityStatus.visible);

      // Build a Widget tree with a KeyboardVisibilityBuilder.
      KeyboardVisibilityStatus? isKeyboardVisible;

      await tester.pumpWidget(
        KeyboardVisibilityBuilder(
          controller: mockController,
          builder: (_, _isKeyboardVisible) {
            isKeyboardVisible = _isKeyboardVisible;
            return SizedBox();
          },
        ),
      );

      // We expect that the keyboard is initially reported as visible.
      expect(isKeyboardVisible, KeyboardVisibilityStatus.visible);

      // Pretend that the keyboard has gone from visible to hidden.
      streamController.add(KeyboardVisibilityStatus.notVisible);
      when(
        mockController.isVisible,
      ).thenAnswer((_) => KeyboardVisibilityStatus.notVisible);

      await tester.pumpAndSettle();

      // Verify that our descendant rebuilt itself, and received the
      // updated visibility of the keyboard.
      expect(isKeyboardVisible, false);
    });
  });

  // TODO this test complains when ran because SizedBox is not hit testable
  // since KeyboardDismissOnTap captures the hit with its GestureDetector
  group('KeyboardDismissOnTap', () {
    testWidgets('It removes focus when tapped', (WidgetTester tester) async {
      var focusNode = FocusNode();
      await tester.pumpWidget(
        MaterialApp(
          home: KeyboardDismissOnTap(
            child: Material(
              child: Column(
                children: [
                  SizedBox(key: Key('box'), height: 100, width: 100),
                  TextField(focusNode: focusNode),
                ],
              ),
            ),
          ),
        ),
      );

      // TextField starts unfocused
      expect(focusNode.hasFocus, false);

      // Focus TextField
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, true);

      // Tapping within KeyboardDismissOnTap removes focus
      await tester.tap(find.byKey(Key('box')));
      expect(focusNode.hasFocus, false);
    });
  });

  group('KeyboardVisibilityTesting', () {
    testWidgets(
      'setVisibilityForTesting allows overriding of value to true for testing',
      (WidgetTester tester) async {
        // Pretend that the keyboard is visible.
        KeyboardVisibilityTesting.setVisibilityForTesting(
          KeyboardVisibilityStatus.visible,
        );

        // Build a Widget tree and query KeyboardVisibilityProvider
        // for the visibility of the keyboard.
        KeyboardVisibilityStatus isKeyboardVisible =
            KeyboardVisibilityStatus.notVisible;

        await tester.pumpWidget(
          KeyboardVisibilityProvider(
            child: Builder(
              builder: (BuildContext context) {
                isKeyboardVisible =
                    KeyboardVisibilityProvider.isKeyboardVisible(context);
                return SizedBox();
              },
            ),
          ),
        );

        // Verify that KeyboardVisibilityProvider reported that the
        // keyboard is visible.
        expect(isKeyboardVisible, KeyboardVisibilityStatus.visible);
      },
    );
    testWidgets(
      'setVisibilityForTesting allows overriding of value to false for testing',
      (WidgetTester tester) async {
        // Pretend that the keyboard is not visible.
        KeyboardVisibilityTesting.setVisibilityForTesting(
          KeyboardVisibilityStatus.notVisible,
        );

        // Build a Widget tree and query KeyboardVisibilityProvider
        // for the visibility of the keyboard.
        KeyboardVisibilityStatus isKeyboardVisible =
            KeyboardVisibilityStatus.visible;

        await tester.pumpWidget(
          KeyboardVisibilityProvider(
            child: Builder(
              builder: (BuildContext context) {
                isKeyboardVisible =
                    KeyboardVisibilityProvider.isKeyboardVisible(context);
                return SizedBox();
              },
            ),
          ),
        );

        // Verify that KeyboardVisibilityProvider reported that the
        // keyboard is visible.
        expect(isKeyboardVisible, KeyboardVisibilityStatus.notVisible);
      },
    );
  });
}
