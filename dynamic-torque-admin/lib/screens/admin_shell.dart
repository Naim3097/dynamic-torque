import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../services/auth_service.dart';
import '../services/realtime_service.dart';
import '../widgets/common/sidebar_nav.dart';
import '../widgets/common/top_bar.dart';
import 'dashboard/dashboard_screen.dart';
import 'orders/order_list_screen.dart';
import 'products/product_list_screen.dart';
import 'customers/customer_list_screen.dart';
import 'notifications/notification_composer_screen.dart';
import 'settings/settings_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;

  static const _titles = [
    'Dashboard',
    'Orders',
    'Products',
    'Customers',
    'Notifications',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _setupRealtime();
  }

  void _setupRealtime() {
    final auth = context.read<AuthService>();
    final admin = auth.currentAdmin;
    if (admin == null) return;

    // Subscribe to new notifications — show a snackbar when one arrives.
    RealtimeService.instance.subscribeToNotifications(
      userId: admin.id,
      onNotification: (payload) {
        if (!mounted) return;
        final title = payload['title'] as String? ?? 'New notification';
        final body = payload['body'] as String? ?? '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title — $body'),
            backgroundColor: AppColors.blueBright,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'View',
              textColor: AppColors.white,
              onPressed: () {
                // Navigate to Orders tab
                setState(() => _selectedIndex = 1);
              },
            ),
          ),
        );
      },
    );

    // Subscribe to order changes — also show a snackbar.
    RealtimeService.instance.subscribeToOrders(
      onOrderChange: (payload) {
        if (!mounted) return;
        final orderNumber = payload['order_number'] as String? ?? '';
        final status = payload['order_status'] as String? ?? '';
        if (orderNumber.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order $orderNumber — $status'),
              backgroundColor: AppColors.bgSecondary,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    RealtimeService.instance.dispose();
    super.dispose();
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const OrderListScreen();
      case 2:
        return const ProductListScreen();
      case 3:
        return const CustomerListScreen();
      case 4:
        return const NotificationComposerScreen();
      case 5:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final useMobileLayout = screenWidth < 768;

    if (useMobileLayout) {
      return Scaffold(
        body: Column(
          children: [
            TopBar(title: _titles[_selectedIndex]),
            Expanded(child: _buildScreen()),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          backgroundColor: const Color(0xFF0A1525),
          indicatorColor: const Color(0x1F2A8FD4),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
            NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
            NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined), label: 'Products'),
            NavigationDestination(
                icon: Icon(Icons.people_outline), label: 'Customers'),
            NavigationDestination(
                icon: Icon(Icons.notifications_outlined), label: 'Notify'),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SidebarNav(
            selectedIndex: _selectedIndex,
            onItemSelected: (i) => setState(() => _selectedIndex = i),
            collapsed: _sidebarCollapsed,
            onToggleCollapsed: () =>
                setState(() => _sidebarCollapsed = !_sidebarCollapsed),
          ),
          Expanded(
            child: Column(
              children: [
                TopBar(title: _titles[_selectedIndex]),
                Expanded(child: _buildScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
