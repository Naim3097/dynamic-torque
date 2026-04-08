import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SidebarNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool collapsed;
  final VoidCallback onToggleCollapsed;

  const SidebarNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.collapsed = false,
    required this.onToggleCollapsed,
  });

  static const _items = <_NavItem>[
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
    _NavItem(icon: Icons.shopping_bag_outlined, activeIcon: Icons.shopping_bag, label: 'Orders'),
    _NavItem(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, label: 'Products'),
    _NavItem(icon: Icons.people_outline, activeIcon: Icons.people, label: 'Customers'),
    _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = collapsed ? 72.0 : 240.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBg,
        border: Border(
          right: BorderSide(color: Color(0x10FFFFFF)),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 20),
            alignment: collapsed ? Alignment.center : Alignment.centerLeft,
            child: collapsed
                ? Text(
                    'DT',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blueBright,
                    ),
                  )
                : Text(
                    'Dynamic Torque',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
          ),

          const Divider(),

          // Nav items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: List.generate(_items.length, (i) {
                  final item = _items[i];
                  final isActive = i == selectedIndex;
                  return _buildNavTile(item, isActive, () => onItemSelected(i));
                }),
              ),
            ),
          ),

          // Collapse toggle
          const Divider(),
          InkWell(
            onTap: onToggleCollapsed,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: Icon(
                collapsed
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(_NavItem item, bool isActive, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isActive ? AppColors.blueBright.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: AppColors.sidebarHover,
          child: Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 14),
            alignment: collapsed ? Alignment.center : Alignment.centerLeft,
            child: Row(
              mainAxisSize: collapsed ? MainAxisSize.min : MainAxisSize.max,
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 20,
                  color: isActive ? AppColors.blueBright : AppColors.textMuted,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive ? AppColors.white : AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(
      {required this.icon, required this.activeIcon, required this.label});
}
