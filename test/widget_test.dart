import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('SmartAttendanceApp smoke test - starts with Splash Screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmartAttendanceApp());
    expect(find.byType(SmartAttendanceApp), findsOneWidget);
  });
}
