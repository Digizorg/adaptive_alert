import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_alert/iterable_extensions.dart';
import 'package:native_alert/native_alert_platform_interface.dart';

enum NativeAlertActionType {
  normal,
  destructive,
  cancel;

  bool get isNormal => this == NativeAlertActionType.normal;
  bool get isDestructive => this == NativeAlertActionType.destructive;
  bool get isCancel => this == NativeAlertActionType.cancel;
}

class NativeAlertAction {
  const NativeAlertAction({
    required this.title,
    this.type = NativeAlertActionType.normal,
    this.onPressed,
  });

  const NativeAlertAction.destructive({required this.title, this.onPressed})
    : type = NativeAlertActionType.destructive;

  const NativeAlertAction.cancel({required this.title, this.onPressed})
    : type = NativeAlertActionType.cancel;

  final String title;
  final NativeAlertActionType type;
  final void Function()? onPressed;
}

/// Shows a customizable dialog that adapts to the current platform. Both iOS
/// and Android versions are available.
Future<void> showNativeAlertDialog(
  BuildContext context, {
  required NativeAlertAction primaryAction,
  NativeAlertAction? secondaryAction,
  String? title,
  String? message,
  bool useRootNavigator = true,
  bool dismissible = true,
}) async {
  assert(title != null || message != null, 'Title or message must be provided');
  assert(
    [
          primaryAction,
          secondaryAction,
        ].where((action) => action?.type.isCancel ?? false).length <=
        1,
    'An alert can only have one action with type cancel.',
  );

  if (Theme.of(context).platform == TargetPlatform.iOS) {
    if (kIsWeb) {
      return showCupertinoDialog(
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (context) => CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: message != null ? Text(message) : null,
          actions: [
            if (secondaryAction != null)
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  secondaryAction.onPressed?.call();
                },
                isDefaultAction: secondaryAction.type.isCancel,
                isDestructiveAction: secondaryAction.type.isDestructive,
                child: Text(secondaryAction.title),
              ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                primaryAction.onPressed?.call();
              },
              isDefaultAction: primaryAction.type.isCancel,
              isDestructiveAction: primaryAction.type.isDestructive,
              child: Text(primaryAction.title),
            ),
          ],
        ),
      );
    }

    final result = await NativeAlertPlatform.instance.showNativeAlertDialog(
      title: title ?? '',
      message: message ?? '',
      primaryButtonTitle: primaryAction.title,
      primaryButtonActionType: primaryAction.type.name,
      secondaryButtonTitle: secondaryAction?.title ?? '',
      secondaryButtonActionType: secondaryAction?.type.name ?? '',
    );

    if (result == 'primary') {
      primaryAction.onPressed?.call();
    } else if (result == 'secondary') {
      secondaryAction?.onPressed?.call();
    }

    return;
  }

  await showDialog<void>(
    context: context,
    useRootNavigator: useRootNavigator,
    barrierDismissible: dismissible,
    builder: (context) {
      return Builder(
        builder: (context) {
          return AlertDialog(
            title: title != null ? Text(title) : null,
            content: message != null ? Text(message) : null,
            actions: [
              if (secondaryAction != null)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    secondaryAction.onPressed?.call();
                  },
                  child: Text(secondaryAction.title),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  primaryAction.onPressed?.call();
                },
                child: Text(primaryAction.title),
              ),
            ],
          );
        },
      );
    },
  );
}

/// Shows a dialog adequate for a single operation that adapts to the current
/// platform. Both iOS and Android versions are available. On iOS, this is
/// rendered as an action sheet, while on Android, it is rendered as a regular
/// dialog. This is useful when the user has to confirm delete operations.
Future<void> showNativeConfirmDialog(
  BuildContext context, {
  required NativeAlertAction confirmAction,
  required NativeAlertAction cancelAction,
  String? title,
  String? message,
  bool useRootNavigator = true,
}) async {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    showNativeActionSheet(
      context,
      title: title,
      message: message,
      actions: [
        NativeAlertAction.destructive(
          title: confirmAction.title,
          onPressed: confirmAction.onPressed,
        ),
      ],
      cancelAction: cancelAction,
    );

    return;
  }

  showNativeAlertDialog(
    context,
    title: title,
    message: message,
    primaryAction: confirmAction,
    secondaryAction: cancelAction,
  );
}

Future<void> showNativeActionSheet(
  BuildContext context, {
  required List<NativeAlertAction> actions,
  required NativeAlertAction cancelAction,
  String? title,
  String? message,
  bool useRootNavigator = true,
}) async {
  // Check if actions list is empty
  assert(actions.isNotEmpty, 'actions list must not be empty');

  // Check if there is at most one NativeAlertAction with type cancel
  final cancelActions = [
    ...actions,
    cancelAction,
  ].where((action) => action.type.isCancel).toList();
  assert(
    cancelActions.length <= 1,
    'There must be at most one action with type NativeAlertActionType.cancel',
  );

  if (Theme.of(context).platform == TargetPlatform.iOS) {
    if (kIsWeb) {
      return showCupertinoModalPopup(
        context: context,
        useRootNavigator: useRootNavigator,
        builder: (context) => CupertinoActionSheet(
          title: title != null ? Text(title) : null,
          message: message != null ? Text(message) : null,
          actions: [
            for (final action in actions)
              CupertinoActionSheetAction(
                isDestructiveAction: action.type.isDestructive,
                onPressed: () {
                  Navigator.of(context).pop();
                  action.onPressed?.call();
                },
                child: Text(action.title),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop();
              cancelAction.onPressed?.call();
            },
            isDefaultAction: cancelAction.type.isCancel,
            isDestructiveAction: cancelAction.type.isDestructive,
            child: Text(cancelAction.title),
          ),
        ),
      );
    }

    final result = await NativeAlertPlatform.instance.showNativeActionSheet(
      title: title,
      message: message,
      actions: actions
          .map((e) => {'title': e.title, 'type': e.type.name})
          .toList(),
      cancelAction: {
        'title': cancelAction.title,
        'type': cancelAction.type.name,
      },
    );

    if (result == 'cancel') {
      cancelAction.onPressed?.call();
    } else if (result != null) {
      final index = int.tryParse(result);
      if (index != null && index >= 0 && index < actions.length) {
        actions[index].onPressed?.call();
      }
    }

    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: useRootNavigator,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
    ),
    showDragHandle: true,
    builder: (BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (title != null) Text(title),
                      if (message != null)
                        Text(message, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Column(
                  children:
                      [
                        for (final action in actions)
                          ListTile(
                            title: Text(action.title),
                            onTap: () {
                              Navigator.of(context).pop();
                              action.onPressed?.call();
                            },
                          ),
                        ListTile(
                          title: Text(cancelAction.title),
                          onTap: () {
                            Navigator.of(context).pop();
                            cancelAction.onPressed?.call();
                          },
                        ),
                        const SizedBox(height: 32),
                      ].withDividerBetween(
                        const Divider(height: 1, indent: 16, endIndent: 16),
                      ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

// extension on DigizorgAdaptiveAlertActionType {
//   IosButtonStyle get toIosButtonStyle {
//     switch (this) {
//       case DigizorgAdaptiveAlertActionType.destructive:
//         return IosButtonStyle.destructive;
//       case DigizorgAdaptiveAlertActionType.normal:
//         return IosButtonStyle.normal;
//       case DigizorgAdaptiveAlertActionType.cancel:
//         return IosButtonStyle.cancel;
//     }
//   }
// }
