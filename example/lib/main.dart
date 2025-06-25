import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:native_alert/native_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Alert Example',
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
            appBar: AppBar(title: const Text('Native Alert Example')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  ElevatedButton(
                    child: const Text('Show Alert'),
                    onPressed: () {
                      showNativeAlertDialog(
                        context,
                        title: 'Alert',
                        message: 'This is an alert',
                        primaryAction: NativeAlertAction.destructive(
                          title: 'OK',
                          onPressed: () {
                            log('OK');
                          },
                        ),
                        secondaryAction: NativeAlertAction.cancel(
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
                      showNativeConfirmDialog(
                        context,
                        title: 'Would you like to delete this item?',
                        message: 'This is a confirm alert',
                        confirmAction: NativeAlertAction.destructive(
                          title: 'Delete',
                          onPressed: () {
                            log('Delete');
                          },
                        ),
                        cancelAction: NativeAlertAction.cancel(
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
                      showNativeActionSheet(
                        context,
                        title: 'Action Sheet',
                        message: 'This is an action sheet',
                        actions: [
                          NativeAlertAction(
                            title: 'Normal 1',
                            onPressed: () {
                              log('Normal 1');
                            },
                          ),
                          NativeAlertAction(
                            title: 'Normal 2',
                            onPressed: () {
                              log('Normal 2');
                            },
                          ),
                          NativeAlertAction.destructive(
                            title: 'Destructive 1',
                            onPressed: () {
                              log('Destructive 1');
                            },
                          ),
                          NativeAlertAction.destructive(
                            title: 'Destructive 2',
                            onPressed: () {
                              log('Destructive 2');
                            },
                          ),
                        ],
                        cancelAction: NativeAlertAction.cancel(
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
