import 'package:flutter/material.dart';

extension ListSpaceBetweenExtension on Iterable<Widget> {
  List<Widget> withDividerBetween(Widget divider) => [
    for (int i = 0; i < length; i++) ...[
      if (i > 0) divider,
      elementAt(i),
    ],
  ];
}
