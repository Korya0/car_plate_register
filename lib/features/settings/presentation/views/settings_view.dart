import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_section_header.dart';
import 'package:car_register/core/widgets/common_sliver_app_bar.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: [
        const CommonSliverAppBar(
          title: AppStrings.settingsTitle,
          hasBackButton: false,
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // General section
                const AppSectionHeader(title: AppStrings.generalSection),

                // Placeholder
                Container(
                  padding: EdgeInsets.all(AppSize.p16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryScaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppSize.r16),
                    border: Border.all(
                      color: AppColors.dividerColor,
                      width: AppSize.borderWidth,
                    ),
                  ),
                  child: Text(
                    AppStrings.settingsPlaceholder,
                    style: AppTextStyles.font14W500Secondary,
                  ),
                ),
                AppGap.h(AppSize.p32),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
