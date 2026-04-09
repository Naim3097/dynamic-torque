import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/supabase_config.dart';
import 'config/theme.dart';
import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.init();

  final authService = AuthService();
  await authService.init();

  runApp(DynamicTorqueAdmin(authService: authService));
}

class DynamicTorqueAdmin extends StatelessWidget {
  final AuthService authService;

  const DynamicTorqueAdmin({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: authService,
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
