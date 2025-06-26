import 'dart:developer';

import 'package:adaptive_alert/adaptive_alert.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive Alert Example',
      home: const MyAppScreen(),
    );
  }
}

class MyAppScreen extends StatelessWidget {
  const MyAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(platform: TargetPlatform.iOS),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Adaptive Alert Example')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  ElevatedButton(
                    child: const Text('Show Alert'),
                    onPressed: () {
                      showAdaptiveAlertDialog(
                        context,
                        title: 'Alert',
                        message: 'This is an alert',
                        primaryAction: AdaptiveAlertAction.destructive(
                          title: 'OK',
                          onPressed: () {
                            log('OK');
                          },
                        ),
                        secondaryAction: AdaptiveAlertAction.cancel(
                          title: 'Cancel',
                          onPressed: () {
                            log('Cancel');
                          },
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Show Confirm Alert'),
                    onPressed: () {
                      showAdaptiveConfirmDialog(
                        context,
                        title: 'Would you like to delete this item?',
                        message: 'This is a confirm alert',
                        confirmAction: AdaptiveAlertAction.destructive(
                          title: 'Delete',
                          onPressed: () {
                            log('Delete');
                          },
                        ),
                        cancelAction: AdaptiveAlertAction.cancel(
                          title: 'Cancel',
                          onPressed: () {
                            log('Cancel');
                          },
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Show Action Sheet'),
                    onPressed: () {
                      showAdaptiveActionSheet(
                        context,
                        title: 'Action Sheet',
                        message: 'This is an action sheet',
                        actions: [
                          AdaptiveAlertAction(
                            title: 'Normal 1',
                            onPressed: () {
                              log('Normal 1');
                            },
                          ),
                          AdaptiveAlertAction(
                            title: 'Normal 2',
                            onPressed: () {
                              log('Normal 2');
                            },
                          ),
                          AdaptiveAlertAction.destructive(
                            title: 'Destructive 1',
                            onPressed: () {
                              log('Destructive 1');
                            },
                          ),
                          AdaptiveAlertAction.destructive(
                            title: 'Destructive 2',
                            onPressed: () {
                              log('Destructive 2');
                            },
                          ),
                        ],
                        cancelAction: AdaptiveAlertAction.cancel(
                          title: 'Cancel',
                          onPressed: () {
                            log('Cancel');
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
