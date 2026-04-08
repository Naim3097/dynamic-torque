import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_torque_admin/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    await tester.pumpWidget(const DynamicTorqueAdmin());
    expect(find.text('Admin Dashboard'), findsOneWidget);
  });
}
