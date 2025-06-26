# adaptive_alert

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
| Others   | Flutter's built-in `AlertDialog` / `ModalBottomSheet`     |

## Getting Started

Add `adaptive_alert` to your `pubspec.yaml` file:

```yaml
dependencies:
  adaptive_alert: ^1.0.0 # Replace with the latest version
```

Then, run `flutter pub get`.

## Usage

Import the package in your Dart file:

```dart
import 'package:adaptive_alert/adaptive_alert.dart';
```

### Defining Actions

Actions are defined using the `AdaptiveAlertAction` class. Each action has a `title`, an optional `onPressed` callback, and a `type` (`AdaptiveAlertActionType`).

```dart
// A standard action
final okAction = AdaptiveAlertAction(
  title: 'OK',
  onPressed: () => print('OK pressed'),
);

// A destructive action
final deleteAction = AdaptiveAlertAction(
  title: 'Delete',
  type: AdaptiveAlertActionType.destructive,
  onPressed: () => print('Delete pressed'),
);

// A cancel action
final cancelAction = AdaptiveAlertAction(
  title: 'Cancel',
  type: AdaptiveAlertActionType.cancel,
  onPressed: () => print('Cancel pressed'),
);
```

### Showing an Alert Dialog

Use `showAdaptiveAlertDialog` to display a standard alert with one or two actions.

```dart
showAdaptiveAlertDialog(
  context,
  title: 'Alert',
  message: 'This is a native alert.',
  primaryAction: okAction,
  secondaryAction: cancelAction,
);
```

### Showing a Confirmation Dialog

Use `showAdaptiveConfirmDialog` for critical actions. On iOS, this renders as an action sheet.

```dart
showAdaptiveConfirmDialog(
  context,
  title: 'Confirm Deletion',
  message: 'Are you sure you want to delete this item?',
  confirmAction: deleteAction,
  cancelAction: cancelAction,
);
```

### Showing an Action Sheet

Use `showAdaptiveActionSheet` to present a list of choices.

```dart
showAdaptiveActionSheet(
  context,
  title: 'Options',
  message: 'Please select an option.',
  actions: [
    AdaptiveAlertAction(title: 'Option 1', onPressed: () {}),
    AdaptiveAlertAction(title: 'Option 2', onPressed: () {}),
    deleteAction,
  ],
  cancelAction: cancelAction,
);
```

## API Reference

- `showAdaptiveAlertDialog`: Displays a standard alert dialog.
- `showAdaptiveConfirmDialog`: Displays a confirmation dialog (or action sheet on iOS).
- `showAdaptiveActionSheet`: Displays an action sheet with a list of options.
- `AdaptiveAlertAction`: A class to define an action for an alert or action sheet.
- `AdaptiveAlertActionType`: An enum for action styles (`normal`, `destructive`, `cancel`).

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on GitHub.

