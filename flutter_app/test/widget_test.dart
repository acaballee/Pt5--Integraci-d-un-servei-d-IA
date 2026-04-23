import 'package:flutter_test/flutter_test.dart';
import 'package:smart_receipt_ai/main.dart';

void main() {
  testWidgets('SmartReceipt app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartReceiptApp());
    expect(find.text('SmartReceipt '), findsOneWidget);
    expect(find.text('Configuració'), findsOneWidget);
    expect(find.text('Entrada de Tiquet'), findsOneWidget);
  });
}
