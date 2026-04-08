import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final admin = auth.currentAdmin;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              fontFamily: 'Rajdhani',
            ),
          ),
          const SizedBox(height: 24),

          // Business profile card
          _card(
            title: 'Business Profile',
            icon: Icons.storefront_rounded,
            children: [
              _row('Company', 'MNA Dynamic Torque'),
              _row('Industry', 'Automotive Parts — Gearbox Specialist'),
              _row('Region', 'Malaysia'),
              _row('Currency', 'MYR (RM)'),
              _row('Website', 'dynamictorque.com'),
            ],
          ),
          const SizedBox(height: 16),

          // Admin user card
          if (admin != null)
            _card(
              title: 'Admin Account',
              icon: Icons.admin_panel_settings_rounded,
              children: [
                _row('Name', admin.fullName),
                _row('Email', admin.email),
                _row('Role', admin.role.toUpperCase()),
              ],
            ),
          const SizedBox(height: 16),

          // App info card
          _card(
            title: 'Application',
            icon: Icons.info_outline_rounded,
            children: [
              _row('App', 'Dynamic Torque Admin Dashboard'),
              _row('Version', '1.0.0'),
              _row('Platform', 'Flutter Web / Windows'),
              _row('State Mgmt', 'Provider'),
            ],
          ),
          const SizedBox(height: 16),

          // Danger zone
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.redAccent.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppColors.redAccent, size: 20),
                    SizedBox(width: 8),
                    Text('Danger Zone',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.redAccent)),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    auth.signOut();
                  },
                  icon: const Icon(Icons.logout,
                      color: AppColors.redAccent, size: 18),
                  label: const Text('Sign Out',
                      style: TextStyle(color: AppColors.redAccent)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.redAccent),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x10FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.blueBright, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white)),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  static Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
