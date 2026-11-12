import 'package:adaptive_alert_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the alert and action sheet examples', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Show Alert'), findsOneWidget);
    expect(find.text('Show Confirm Alert'), findsOneWidget);
    expect(find.text('Show Action Sheet'), findsOneWidget);
  });
}
