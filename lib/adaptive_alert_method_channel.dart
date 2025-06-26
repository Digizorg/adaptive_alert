import 'package:adaptive_alert/adaptive_alert_platform_interface.dart'
    show AdaptiveAlertPlatform;
import 'package:adaptive_alert/adaptive_alert_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An implementation of [AdaptiveAlertPlatform] that uses method channels.
class MethodChannelAdaptiveAlert extends AdaptiveAlertPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app.digizorg.adaptive_alert');

  @override
  Future<String?> showAdaptiveAlertDialog({
    required String title,
    required String message,
    required String primaryButtonTitle,
    required String primaryButtonActionType,
    String? secondaryButtonTitle,
    String? secondaryButtonActionType,
  }) async {
    final result = await methodChannel.invokeMethod<String>(
      'showAdaptiveAlertDialog',
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
  Future<String?> showAdaptiveActionSheet({
    required List<Map<String, String?>> actions,
    required Map<String, String?> cancelAction,
    String? title,
    String? message,
  }) async {
    final result = await methodChannel.invokeMethod<String>(
      'showAdaptiveActionSheet',
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
