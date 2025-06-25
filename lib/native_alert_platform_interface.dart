import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_alert_method_channel.dart';

abstract class NativeAlertPlatform extends PlatformInterface {
  /// Constructs a NativeAlertPlatform.
  NativeAlertPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeAlertPlatform _instance = MethodChannelNativeAlert();

  /// The default instance of [NativeAlertPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeAlert].
  static NativeAlertPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeAlertPlatform] when
  /// they register themselves.
  static set instance(NativeAlertPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

    Future<String?> showNativeAlertDialog({
    required String title,
    required String message,
    required String primaryButtonTitle,
    required String primaryButtonActionType,
    String? secondaryButtonTitle,
    String? secondaryButtonActionType,
  }) {
    throw UnimplementedError('showNativeAlertDialog() has not been implemented.');
  }

  Future<String?> showNativeActionSheet({
    String? title,
    String? message,
    required List<Map<String, String?>> actions,
    required Map<String, String?> cancelAction,
  }) {
    throw UnimplementedError('showNativeActionSheet() has not been implemented.');
  }
}
