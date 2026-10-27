import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/widgets/app_bottom_nav_bar.dart';
import 'package:car_register/core/widgets/bottom_nav_tab_config.dart';

const List<BottomNavTabConfig> mainBottomNavTabs = [
  BottomNavTabConfig(label: AppStrings.homeTab, icon: Icons.home_rounded),
  BottomNavTabConfig(
    label: AppStrings.brochuresTab,
    icon: Icons.notes_rounded,
  ),
];

class MainView extends StatelessWidget {
  const MainView({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: navigationShell.currentIndex == 0,
    onPopInvokedWithResult: (didPop, _) {
      if (didPop) return;
      navigationShell.goBranch(0, initialLocation: true);
    },
    child: Scaffold(
      // Body
      body: navigationShell,

      // Bottom navigation
      bottomNavigationBar: AppBottomNavBar(
        tabs: mainBottomNavTabs,
        currentIndex: navigationShell.currentIndex,
        onTabSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    ),
  );
}
