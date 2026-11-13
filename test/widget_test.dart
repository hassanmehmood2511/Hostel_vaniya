import 'package:flutter_test/flutter_test.dart';
import 'package:hostel_vaniya/main.dart';

void main() {
  testWidgets('Welcome screen shows the primary actions', (WidgetTester tester) async {
    await tester.pumpWidget(const HostelVaniyaApp());
    await tester.pumpAndSettle();

    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });
}
