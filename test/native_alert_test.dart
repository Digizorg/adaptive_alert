import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_alert/native_alert.dart';
import 'package:native_alert/native_alert_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NativeAlert', () {
    const channel = MethodChannel('app.digizorg.native_alert');
    final log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return ''; // Return a mock value
      });
      log.clear();
    });

    test('showNativeAlertDialog sends correct arguments', () async {
      await NativeAlertPlatform.instance.showNativeAlertDialog(
        title: 'Test Title',
        message: 'Test Message',
        primaryButtonTitle: 'OK',
        primaryButtonActionType: 'normal',
        secondaryButtonTitle: 'Cancel',
        secondaryButtonActionType: 'cancel',
      );

      expect(log, <Matcher>[
        isMethodCall('showNativeAlertDialog', arguments: {
          'title': 'Test Title',
          'message': 'Test Message',
          'primaryButtonTitle': 'OK',
          'primaryButtonActionType': 'normal',
          'secondaryButtonTitle': 'Cancel',
          'secondaryButtonActionType': 'cancel',
        }),
      ]);
    });

    test('showNativeActionSheet sends correct arguments', () async {
      await NativeAlertPlatform.instance.showNativeActionSheet(
        title: 'Action Sheet',
        message: 'Select an option',
        actions: [
          {'title': 'Option 1', 'type': 'normal'},
          {'title': 'Option 2', 'type': 'destructive'},
        ],
        cancelAction: {'title': 'Cancel', 'type': 'cancel'},
      );

      expect(log, <Matcher>[
        isMethodCall('showNativeActionSheet', arguments: {
          'title': 'Action Sheet',
          'message': 'Select an option',
          'actions': [
            {'title': 'Option 1', 'type': 'normal'},
            {'title': 'Option 2', 'type': 'destructive'},
          ],
          'cancelAction': {'title': 'Cancel', 'type': 'cancel'},
        }),
      ]);
    });

    test('showNativeAlertDialog with only primary action sends correct arguments', () async {
      await NativeAlertPlatform.instance.showNativeAlertDialog(
        title: 'Test Title',
        message: 'Test Message',
        primaryButtonTitle: 'OK',
        primaryButtonActionType: 'normal',
        secondaryButtonTitle: null,
        secondaryButtonActionType: null,
      );

      expect(log, <Matcher>[
        isMethodCall('showNativeAlertDialog', arguments: {
          'title': 'Test Title',
          'message': 'Test Message',
          'primaryButtonTitle': 'OK',
          'primaryButtonActionType': 'normal',
          'secondaryButtonTitle': null,
          'secondaryButtonActionType': null,
        }),
      ]);
    });

    test('showNativeActionSheet with no title/message sends correct arguments', () async {
      await NativeAlertPlatform.instance.showNativeActionSheet(
        title: null,
        message: null,
        actions: [
          {'title': 'Option 1', 'type': 'normal'},
        ],
        cancelAction: {'title': 'Cancel', 'type': 'cancel'},
      );

      expect(log, <Matcher>[
        isMethodCall('showNativeActionSheet', arguments: {
          'title': null,
          'message': null,
          'actions': [
            {'title': 'Option 1', 'type': 'normal'},
          ],
          'cancelAction': {'title': 'Cancel', 'type': 'cancel'},
        }),
      ]);
    });
  });

  group('NativeAlert Assertions', () {
    testWidgets('showNativeActionSheet throws assertion for empty actions', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            expect(
              () => showNativeActionSheet(
                context,
                actions: [],
                cancelAction: const NativeAlertAction.cancel(title: 'Cancel'),
              ),
              throwsAssertionError,
            );
            return Container();
          },
        ),
      ));
    });

    testWidgets('showNativeActionSheet throws assertion for wrong cancel type', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            expect(
              () => showNativeActionSheet(
                context,
                actions: [const NativeAlertAction(title: 'OK')],
                cancelAction: const NativeAlertAction(title: 'Cancel'), // Not type cancel
              ),
              throwsAssertionError,
            );
            return Container();
          },
        ),
      ));
    });

    testWidgets('showNativeActionSheet throws assertion for multiple cancel actions', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            expect(
              () => showNativeActionSheet(
                context,
                actions: [const NativeAlertAction.cancel(title: 'Cancel 1')],
                cancelAction: const NativeAlertAction.cancel(title: 'Cancel 2'),
              ),
              throwsAssertionError,
            );
            return Container();
          },
        ),
      ));
    });
  });

  group('Fallback UI Tests', () {
    testWidgets('showNativeAlertDialog shows Material dialog on Android', (tester) async {
      final originalPlatform = debugDefaultTargetPlatformOverride;
      try {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        var primaryPressed = false;

        await tester.pumpWidget(MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showNativeAlertDialog(
                context,
                title: 'Android Alert',
                message: 'This is a Material dialog.',
                primaryAction: NativeAlertAction(
                  title: 'OK',
                  onPressed: () => primaryPressed = true,
                ),
                secondaryAction: const NativeAlertAction(
                  title: 'Cancel',
                ),
              ),
              child: const Text('Show Alert'),
            ),
          ),
        ));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Android Alert'), findsOneWidget);
        expect(find.text('This is a Material dialog.'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);

        await tester.tap(find.text('OK'));
        expect(primaryPressed, isTrue);
      } finally {
        debugDefaultTargetPlatformOverride = originalPlatform;
      }
    });

    testWidgets('showNativeActionSheet shows BottomSheet on Android', (tester) async {
      final originalPlatform = debugDefaultTargetPlatformOverride;
      try {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        var action1Pressed = false;

        await tester.pumpWidget(MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showNativeActionSheet(
                context,
                title: 'Android Sheet',
                actions: [
                  NativeAlertAction(
                    title: 'Action 1',
                    onPressed: () => action1Pressed = true,
                  ),
                ],
                cancelAction: const NativeAlertAction.cancel(title: 'Cancel'),
              ),
              child: const Text('Show Sheet'),
            ),
          ),
        ));

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(find.byType(BottomSheet), findsOneWidget);
        expect(find.text('Android Sheet'), findsOneWidget);
        expect(find.widgetWithText(ListTile, 'Action 1'), findsOneWidget);

        await tester.tap(find.text('Action 1'));
        expect(action1Pressed, isTrue);
      } finally {
        debugDefaultTargetPlatformOverride = originalPlatform;
      }
    });
  });
}
