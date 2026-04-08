import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin_shell.dart';

void main() {
  runApp(const DynamicTorqueAdmin());
}

class DynamicTorqueAdmin extends StatelessWidget {
  const DynamicTorqueAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Dynamic Torque Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(),
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (auth.isAuthenticated) {
      return const AdminShell();
    }
    return const LoginScreen();
  }
}
