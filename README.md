# native_alert

A Flutter plugin to show native alerts and action sheets on iOS, with adaptive fallbacks for other platforms.

This package provides a simple way to display platform-native dialogs. On iOS, it uses `UIAlertController` to present alerts and action sheets, ensuring a seamless user experience. On other platforms like Android and web, it gracefully falls back to Flutter's built-in widgets.

## Features

- **Native iOS Look and Feel**: Uses `UIAlertController` for authentic iOS alerts and action sheets.
- **Adaptive Fallbacks**: Provides Material `AlertDialog` and `ModalBottomSheet` widgets for non-iOS platforms.
- **Customizable Actions**: Define actions with different styles (`normal`, `destructive`, `cancel`).
- **Simple API**: Easy-to-use functions for common dialog patterns.
- **Type-Safe**: Prevents common errors, like adding multiple cancel buttons.

## Platform Support

| Platform | Implementation                                            |
|----------|-----------------------------------------------------------|
| **iOS**  | **Native `UIAlertController`**                            |
| Android  | Material `AlertDialog` / `ModalBottomSheet`               |
| Web      | Cupertino `CupertinoAlertDialog` / `CupertinoActionSheet` |
| macOS    | Material `AlertDialog` / `ModalBottomSheet`               |
| Windows  | Material `AlertDialog` / `ModalBottomSheet`               |
| Linux    | Material `AlertDialog` / `ModalBottomSheet`               |

## Getting Started

Add `native_alert` to your `pubspec.yaml` file:

```yaml
dependencies:
  native_alert: ^1.0.0 # Replace with the latest version
```

Then, run `flutter pub get`.

## Usage

Import the package in your Dart file:

```dart
import 'package:native_alert/native_alert.dart';
```

### Defining Actions

Actions are defined using the `NativeAlertAction` class. Each action has a `title`, an optional `onPressed` callback, and a `type` (`NativeAlertActionType`).

```dart
// A standard action
final okAction = NativeAlertAction(
  title: 'OK',
  onPressed: () => print('OK pressed'),
);

// A destructive action
final deleteAction = NativeAlertAction(
  title: 'Delete',
  type: NativeAlertActionType.destructive,
  onPressed: () => print('Delete pressed'),
);

// A cancel action
final cancelAction = NativeAlertAction(
  title: 'Cancel',
  type: NativeAlertActionType.cancel,
  onPressed: () => print('Cancel pressed'),
);
```

### Showing an Alert Dialog

Use `showNativeAlertDialog` to display a standard alert with one or two actions.

```dart
showNativeAlertDialog(
  context,
  title: 'Alert',
  message: 'This is a native alert.',
  primaryAction: okAction,
  secondaryAction: cancelAction,
);
```

### Showing a Confirmation Dialog

Use `showNativeConfirmDialog` for critical actions. On iOS, this renders as an action sheet.

```dart
showNativeConfirmDialog(
  context,
  title: 'Confirm Deletion',
  message: 'Are you sure you want to delete this item?',
  confirmAction: deleteAction,
  cancelAction: cancelAction,
);
```

### Showing an Action Sheet

Use `showNativeActionSheet` to present a list of choices.

```dart
showNativeActionSheet(
  context,
  title: 'Options',
  message: 'Please select an option.',
  actions: [
    NativeAlertAction(title: 'Option 1', onPressed: () {}),
    NativeAlertAction(title: 'Option 2', onPressed: () {}),
    deleteAction,
  ],
  cancelAction: cancelAction,
);
```

## API Reference

- `showNativeAlertDialog`: Displays a standard alert dialog.
- `showNativeConfirmDialog`: Displays a confirmation dialog (or action sheet on iOS).
- `showNativeActionSheet`: Displays an action sheet with a list of options.
- `NativeAlertAction`: A class to define an action for an alert or action sheet.
- `NativeAlertActionType`: An enum for action styles (`normal`, `destructive`, `cancel`).

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

