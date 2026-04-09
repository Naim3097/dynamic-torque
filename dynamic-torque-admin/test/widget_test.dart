import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_torque_admin/main.dart';
import 'package:dynamic_torque_admin/services/auth_service.dart';

void main() {
  testWidgets('App renders login screen when not authenticated',
      (WidgetTester tester) async {
    final authService = AuthService();
    await tester.pumpWidget(DynamicTorqueAdmin(authService: authService));
    await tester.pump();
    expect(find.text('Sign in'), findsWidgets);
  });
}
