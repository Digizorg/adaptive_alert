import 'package:adaptive_alert/adaptive_alert_platform_interface.dart';
import 'package:adaptive_alert/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// The type of an action in an adaptive alert dialog.
enum AdaptiveAlertActionType {
  /// A normal action.
  normal,

  /// A destructive action.
  destructive,

  /// A cancel action.
  cancel;

  /// Returns true if this action is a normal action.
  bool get isNormal => this == AdaptiveAlertActionType.normal;

  /// Returns true if this action is a destructive action.
  bool get isDestructive => this == AdaptiveAlertActionType.destructive;

  /// Returns true if this action is a cancel action.
  bool get isCancel => this == AdaptiveAlertActionType.cancel;
}

/// An action in an adaptive alert dialog.
class AdaptiveAlertAction {
  /// Creates a new [AdaptiveAlertAction].
  const AdaptiveAlertAction({
    required this.title,
    this.type = AdaptiveAlertActionType.normal,
    this.onPressed,
  });

  /// Creates a new [AdaptiveAlertAction] with a destructive type.
  const AdaptiveAlertAction.destructive({required this.title, this.onPressed})
    : type = AdaptiveAlertActionType.destructive;

  /// Creates a new [AdaptiveAlertAction] with a cancel type.
  const AdaptiveAlertAction.cancel({required this.title, this.onPressed})
    : type = AdaptiveAlertActionType.cancel;

  /// The title of the action.
  final String title;

  /// The type of the action.
  final AdaptiveAlertActionType type;

  /// The callback function to be called when the action is pressed.
  final void Function()? onPressed;
}

/// Displays an adaptive alert dialog.
///
/// On iOS, this function uses a native `UIAlertController` with the `.alert`
/// style, providing a familiar and seamless user experience. On other platforms
/// (like Android), it falls back to Flutter's standard `AlertDialog`.
///
/// The dialog includes a [title], a [message], and up to two actions:
/// [primaryAction] and an optional [secondaryAction]. The appearance and
/// behavior of these actions are determined by their `AdaptiveAlertActionType`.
///
/// - [context]: The `BuildContext` from which to present the dialog.
/// - [primaryAction]: The main action button for the dialog.
/// - [secondaryAction]: An optional secondary action button.
/// - [title]: The title of the dialog.
/// - [message]: The main content of the dialog.
/// - [useRootNavigator]: Whether to use the root navigator for presenting the
/// dialog. Not used on native iOS.
/// - [dismissible]: Whether the dialog can be dismissed by tapping outside of
/// it. Not used on native iOS.
Future<void> showAdaptiveAlertDialog(
  BuildContext context, {
  required AdaptiveAlertAction primaryAction,
  AdaptiveAlertAction? secondaryAction,
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

    final result = await AdaptiveAlertPlatform.instance.showAdaptiveAlertDialog(
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

/// Displays a confirmation dialog that is ideal for critical actions like
/// deletions or other irreversible operations.
///
/// This function is designed to provide a consistent yet platform-idiomatic way
/// to ask for user confirmation. On iOS, it presents a native action sheet,
/// which is the standard for such interactions. On other platforms, it uses a
/// standard alert dialog.
///
/// - [context]: The `BuildContext` from which to present the dialog.
/// - [confirmAction]: The action that confirms the operation, typically
/// destructive.
/// - [cancelAction]: The action that cancels the operation.
/// - [title]: The title of the dialog.
/// - [message]: The descriptive message explaining the action.
/// - [useRootNavigator]: Whether to use the root navigator for presenting the
/// dialog. Not used on native iOS.
Future<void> showAdaptiveConfirmDialog(
  BuildContext context, {
  required AdaptiveAlertAction confirmAction,
  required AdaptiveAlertAction cancelAction,
  String? title,
  String? message,
  bool useRootNavigator = true,
}) async {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    await showAdaptiveActionSheet(
      context,
      title: title,
      message: message,
      actions: [
        AdaptiveAlertAction.destructive(
          title: confirmAction.title,
          onPressed: confirmAction.onPressed,
        ),
      ],
      cancelAction: cancelAction,
    );

    return;
  }

  await showAdaptiveAlertDialog(
    context,
    title: title,
    message: message,
    primaryAction: confirmAction,
    secondaryAction: cancelAction,
  );
}

/// Shows an adaptive action sheet.
///
/// On iOS, this function displays a native `UIAlertController` with the
/// `.actionSheet` style, which is the standard for presenting a set of choices
/// related to a user's current context. On other platforms, it gracefully falls
/// back to a `ModalBottomSheet`, providing a similar user experience.
///
/// The action sheet consists of a list of [actions] and a separate
/// [cancelAction].
/// The cancel action is visually distinct and handled separately on iOS to
/// match the platform's design guidelines.
///
/// - [context]: The `BuildContext` from which to present the action sheet.
/// - [actions]: A list of `AdaptiveAlertAction`s to display as choices.
/// - [cancelAction]: The action that dismisses the action sheet without
/// performing any operation. Must be of type `AdaptiveAlertActionType.cancel`.
/// - [title]: An optional title for the action sheet.
/// - [message]: An optional message displayed below the title.
/// - [useRootNavigator]: Whether to use the root navigator for presenting the
/// action sheet. Not used on native iOS.
Future<void> showAdaptiveActionSheet(
  BuildContext context, {
  required List<AdaptiveAlertAction> actions,
  required AdaptiveAlertAction cancelAction,
  String? title,
  String? message,
  bool useRootNavigator = true,
}) async {
  // Check if actions list is empty
  assert(actions.isNotEmpty, 'actions list must not be empty');

  // Check if cancelAction is of type cancel
  assert(cancelAction.type.isCancel, 'cancelAction must be of type cancel');

  // Check if there is at most one AdaptiveAlertAction with type cancel
  final cancelActions = [
    ...actions,
    cancelAction,
  ].where((action) => action.type.isCancel).toList();
  assert(
    cancelActions.length <= 1,
    'There must be at most one action with type AdaptiveAlertActionType.cancel',
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
            isDefaultAction: true,
            child: Text(cancelAction.title),
          ),
        ),
      );
    }

    final result = await AdaptiveAlertPlatform.instance.showAdaptiveActionSheet(
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
