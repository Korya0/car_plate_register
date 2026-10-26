import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_icon_button.dart';

class CommonSliverAppBar extends StatelessWidget {
  const CommonSliverAppBar({
    super.key,
    this.title,
    this.onBackPressed,
    this.actions,
    this.hasBackButton = true,
    this.isPinned = false,
  });

  final String? title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final bool hasBackButton;
  final bool isPinned;

  @override
  Widget build(BuildContext context) => SliverAppBar(
    backgroundColor: AppColors.scaffoldBackgroundColor,
    elevation: AppConstants.elevationNone,
    scrolledUnderElevation: AppConstants.elevationNone,
    floating: !isPinned,
    snap: !isPinned,
    pinned: isPinned,
    automaticallyImplyLeading: false,
    leading: hasBackButton
        ? Center(
            child: AppIconButton(
              icon: Icons.arrow_back,
              tooltip: AppStrings.back,
              onPressed:
                  onBackPressed ?? () => Navigator.of(context).maybePop(),
            ),
          )
        : null,
    title: title == null
        ? null
        : Text(
            title!,
            maxLines: AppConstants.maxOneLine,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font16W700Primary,
          ),
    centerTitle: true,
    actions: actions,
  );
}
