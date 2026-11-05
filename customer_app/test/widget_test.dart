import 'package:flutter_test/flutter_test.dart';
import 'package:customer_app/main.dart';

void main() {
  testWidgets('Customer App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const LokiCustomerApp());
    expect(find.byType(LokiCustomerApp), findsOneWidget);
  });
}
