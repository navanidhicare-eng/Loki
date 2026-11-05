import 'package:flutter_test/flutter_test.dart';
import 'package:partner_app/main.dart';

void main() {
  testWidgets('Partner App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const LokiPartnerApp());
    expect(find.byType(LokiPartnerApp), findsOneWidget);
  });
}
