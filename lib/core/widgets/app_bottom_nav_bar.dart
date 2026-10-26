import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_pressable.dart';
import 'package:car_register/core/widgets/bottom_nav_tab_config.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
  });

  final List<BottomNavTabConfig> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.secondaryScaffoldBackgroundColor,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.all(AppSize.p8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.dividerColor,
                width: AppSize.borderWidth,
              ),
            ),
          ),
          child: Row(
            children: [
              for (var index = 0; index < tabs.length; index++)
                Expanded(
                  child: _NavItemWidget(
                    tab: tabs[index],
                    isActive: index == currentIndex,
                    onTap: () => onTabSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  const _NavItemWidget({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  final BottomNavTabConfig tab;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.iconBrand : AppColors.iconSecondary;

    // Item (icon + label)
    return AppPressable(
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Icon(tab.icon, size: AppSize.icon24, color: color),

          // Label
          AppGap.h(AppSize.p4),
          Text(
            tab.label,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            style: isActive
                ? AppTextStyles.font12W700Brand
                : AppTextStyles.font12W500Secondary,
          ),
        ],
      ),
    );
  }
}
