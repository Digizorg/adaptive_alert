import 'package:adaptive_alert/adaptive_alert_method_channel.dart'
    show MethodChannelAdaptiveAlert;
import 'package:adaptive_alert/adaptive_alert_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of AdaptiveAlert must implement.
abstract class AdaptiveAlertPlatform extends PlatformInterface {
  /// Constructs a AdaptiveAlertPlatform.
  AdaptiveAlertPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdaptiveAlertPlatform _instance = MethodChannelAdaptiveAlert();

  /// The default instance of [AdaptiveAlertPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdaptiveAlert].
  static AdaptiveAlertPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdaptiveAlertPlatform] when
  /// they register themselves.
  static set instance(AdaptiveAlertPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Shows an adaptive alert dialog.
  Future<String?> showAdaptiveAlertDialog({
    required String title,
    required String message,
    required String primaryButtonTitle,
    required String primaryButtonActionType,
    String? secondaryButtonTitle,
    String? secondaryButtonActionType,
  }) {
    throw UnimplementedError(
      'showAdaptiveAlertDialog() has not been implemented.',
    );
  }

  /// Shows an adaptive action sheet.
  Future<String?> showAdaptiveActionSheet({
    required List<Map<String, String?>> actions,
    required Map<String, String?> cancelAction,
    String? title,
    String? message,
  }) {
    throw UnimplementedError(
      'showAdaptiveActionSheet() has not been implemented.',
    );
  }
}
