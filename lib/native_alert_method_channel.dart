import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:native_alert/native_alert_platform_interface.dart';

/// An implementation of [NativeAlertPlatform] that uses method channels.
class MethodChannelNativeAlert extends NativeAlertPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app.digizorg.native_alert');

  @override
  Future<String?> showNativeAlertDialog({
    required String title,
    required String message,
    required String primaryButtonTitle,
    required String primaryButtonActionType,
    String? secondaryButtonTitle,
    String? secondaryButtonActionType,
  }) async {
    final result = await methodChannel.invokeMethod<String>(
      'showNativeAlertDialog',
      {
        'title': title,
        'message': message,
        'primaryButtonTitle': primaryButtonTitle,
        'primaryButtonActionType': primaryButtonActionType,
        'secondaryButtonTitle': secondaryButtonTitle,
        'secondaryButtonActionType': secondaryButtonActionType,
      },
    );
    return result;
  }

  @override
  Future<String?> showNativeActionSheet({
    required List<Map<String, String?>> actions,
    required Map<String, String?> cancelAction,
    String? title,
    String? message,
  }) async {
    final result = await methodChannel.invokeMethod<String>(
      'showNativeActionSheet',
      {
        'title': title,
        'message': message,
        'actions': actions,
        'cancelAction': cancelAction,
      },
    );
    return result;
  }
}
