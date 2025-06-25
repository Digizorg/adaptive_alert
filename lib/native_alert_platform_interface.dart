import 'package:native_alert/native_alert_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of NativeAlert must implement.
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

  /// Shows a native alert dialog.
  Future<String?> showNativeAlertDialog({
    required String title,
    required String message,
    required String primaryButtonTitle,
    required String primaryButtonActionType,
    String? secondaryButtonTitle,
    String? secondaryButtonActionType,
  }) {
    throw UnimplementedError(
      'showNativeAlertDialog() has not been implemented.',
    );
  }

  /// Shows a native action sheet.
  Future<String?> showNativeActionSheet({
    required List<Map<String, String?>> actions,
    required Map<String, String?> cancelAction,
    String? title,
    String? message,
  }) {
    throw UnimplementedError(
      'showNativeActionSheet() has not been implemented.',
    );
  }
}
