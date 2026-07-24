import 'package:flutter_test/flutter_test.dart';
import 'package:tinamartevent/main.dart';

void main() {
  testWidgets('Tina Notification App loads', (WidgetTester tester) async {
    // Load the application
    await tester.pumpWidget(const TinaMartApp());

    // Verify the app starts
    expect(find.byType(TinaMartApp), findsOneWidget);
  });
}