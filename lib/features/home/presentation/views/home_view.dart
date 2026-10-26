import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_assets.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_divider.dart';
import 'package:car_register/core/widgets/app_empty_view.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/common_sliver_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: [
        const CommonSliverAppBar(
          title: AppStrings.homeTitle,
          hasBackButton: false,
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.p24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Brand
                Center(
                  child: Image.asset(
                    AppAssets.appIcon,
                    width: AppSize.h150,
                    semanticLabel: AppStrings.appName,
                  ),
                ),
                AppGap.h(AppSize.p24),

                // App name
                Text(
                  AppStrings.appName,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font32W800Brand,
                ),
                AppGap.h(AppSize.p8),

                // Subtitle
                Text(
                  AppStrings.homeSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14W500Secondary,
                ),
                AppGap.h(AppSize.p24),

                // Separator
                const AppDivider.horizontal(),
                AppGap.h(AppSize.p24),

                // Empty state
                const AppEmptyView(message: AppStrings.emptyMessage),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(child: AppGap.h(AppSize.p32)),
      ],
    ),
  );
}
