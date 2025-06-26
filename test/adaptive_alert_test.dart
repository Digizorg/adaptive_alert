//
// ignore_for_file: lines_longer_than_80_chars

import 'package:adaptive_alert/adaptive_alert.dart';
import 'package:adaptive_alert/adaptive_alert_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdaptiveAlert', () {
    const channel = MethodChannel('app.digizorg.adaptive_alert');
    final log = <MethodCall>[];

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
            log.add(methodCall);
            return ''; // Return a mock value
          });
      log.clear();
    });

    test('showAdaptiveAlertDialog sends correct arguments', () async {
      await AdaptiveAlertPlatform.instance.showAdaptiveAlertDialog(
        title: 'Test Title',
        message: 'Test Message',
        primaryButtonTitle: 'OK',
        primaryButtonActionType: 'normal',
        secondaryButtonTitle: 'Cancel',
        secondaryButtonActionType: 'cancel',
      );

      expect(log, <Matcher>[
        isMethodCall(
          'showAdaptiveAlertDialog',
          arguments: {
            'title': 'Test Title',
            'message': 'Test Message',
            'primaryButtonTitle': 'OK',
            'primaryButtonActionType': 'normal',
            'secondaryButtonTitle': 'Cancel',
            'secondaryButtonActionType': 'cancel',
          },
        ),
      ]);
    });

    test('showAdaptiveActionSheet sends correct arguments', () async {
      await AdaptiveAlertPlatform.instance.showAdaptiveActionSheet(
        title: 'Action Sheet',
        message: 'Select an option',
        actions: [
          {'title': 'Option 1', 'type': 'normal'},
          {'title': 'Option 2', 'type': 'destructive'},
        ],
        cancelAction: {'title': 'Cancel', 'type': 'cancel'},
      );

      expect(log, <Matcher>[
        isMethodCall(
          'showAdaptiveActionSheet',
          arguments: {
            'title': 'Action Sheet',
            'message': 'Select an option',
            'actions': [
              {'title': 'Option 1', 'type': 'normal'},
              {'title': 'Option 2', 'type': 'destructive'},
            ],
            'cancelAction': {'title': 'Cancel', 'type': 'cancel'},
          },
        ),
      ]);
    });

    test(
      'showAdaptiveAlertDialog with only primary action sends correct arguments',
      () async {
        await AdaptiveAlertPlatform.instance.showAdaptiveAlertDialog(
          title: 'Test Title',
          message: 'Test Message',
          primaryButtonTitle: 'OK',
          primaryButtonActionType: 'normal',
        );

        expect(log, <Matcher>[
          isMethodCall(
            'showAdaptiveAlertDialog',
            arguments: {
              'title': 'Test Title',
              'message': 'Test Message',
              'primaryButtonTitle': 'OK',
              'primaryButtonActionType': 'normal',
              'secondaryButtonTitle': null,
              'secondaryButtonActionType': null,
            },
          ),
        ]);
      },
    );

    test(
      'showAdaptiveActionSheet with no title/message sends correct arguments',
      () async {
        await AdaptiveAlertPlatform.instance.showAdaptiveActionSheet(
          actions: [
            {'title': 'Option 1', 'type': 'normal'},
          ],
          cancelAction: {'title': 'Cancel', 'type': 'cancel'},
        );

        expect(log, <Matcher>[
          isMethodCall(
            'showAdaptiveActionSheet',
            arguments: {
              'title': null,
              'message': null,
              'actions': [
                {'title': 'Option 1', 'type': 'normal'},
              ],
              'cancelAction': {'title': 'Cancel', 'type': 'cancel'},
            },
          ),
        ]);
      },
    );
  });

  group('AdaptiveAlert Assertions', () {
    testWidgets('showAdaptiveActionSheet throws assertion for empty actions', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(
                () => showAdaptiveActionSheet(
                  context,
                  actions: [],
                  cancelAction: const AdaptiveAlertAction.cancel(
                    title: 'Cancel',
                  ),
                ),
                throwsAssertionError,
              );
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets(
      'showAdaptiveActionSheet throws assertion for wrong cancel type',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  () => showAdaptiveActionSheet(
                    context,
                    actions: [const AdaptiveAlertAction(title: 'OK')],
                    cancelAction: const AdaptiveAlertAction(
                      title: 'Cancel',
                    ), // Not type cancel
                  ),
                  throwsAssertionError,
                );
                return Container();
              },
            ),
          ),
        );
      },
    );

    testWidgets(
      'showAdaptiveActionSheet throws assertion for multiple cancel actions',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                expect(
                  () => showAdaptiveActionSheet(
                    context,
                    actions: [
                      const AdaptiveAlertAction.cancel(title: 'Cancel 1'),
                    ],
                    cancelAction: const AdaptiveAlertAction.cancel(
                      title: 'Cancel 2',
                    ),
                  ),
                  throwsAssertionError,
                );
                return Container();
              },
            ),
          ),
        );
      },
    );
  });

  group('Fallback UI Tests', () {
    testWidgets('showAdaptiveAlertDialog shows Material dialog on Android', (
      tester,
    ) async {
      final originalPlatform = debugDefaultTargetPlatformOverride;
      try {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        var primaryPressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showAdaptiveAlertDialog(
                  context,
                  title: 'Android Alert',
                  message: 'This is a Material dialog.',
                  primaryAction: AdaptiveAlertAction(
                    title: 'OK',
                    onPressed: () => primaryPressed = true,
                  ),
                  secondaryAction: const AdaptiveAlertAction(
                    title: 'Cancel',
                  ),
                ),
                child: const Text('Show Alert'),
              ),
            ),
          ),
        );

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

    testWidgets('showAdaptiveActionSheet shows BottomSheet on Android', (
      tester,
    ) async {
      final originalPlatform = debugDefaultTargetPlatformOverride;
      try {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        var action1Pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showAdaptiveActionSheet(
                  context,
                  title: 'Android Sheet',
                  actions: [
                    AdaptiveAlertAction(
                      title: 'Action 1',
                      onPressed: () => action1Pressed = true,
                    ),
                  ],
                  cancelAction: const AdaptiveAlertAction.cancel(
                    title: 'Cancel',
                  ),
                ),
                child: const Text('Show Sheet'),
              ),
            ),
          ),
        );

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
