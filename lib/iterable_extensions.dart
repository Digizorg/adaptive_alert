import 'package:flutter/material.dart';

/// Extension on [Iterable<Widget>].
extension ListSpaceBetweenExtension on Iterable<Widget> {
  /// Returns a new list with a divider inserted between each widget.
  List<Widget> withDividerBetween(Widget divider) {
    return [
      for (int i = 0; i < length; i++) ...[
        if (i > 0) divider,
        elementAt(i),
      ],
    ];
  }
}
