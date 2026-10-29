import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_gap.dart';

class HomeIndexedLabel extends StatelessWidget {
  const HomeIndexedLabel({
    required this.index,
    required this.label,
    super.key,
  });

  final String index;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Index
      Text(index, style: AppTextStyles.font16W700OnSecondary),
      AppGap.w(AppSize.p4),

      // Separator
      Text(
        AppStrings.headerSlash,
        style: AppTextStyles.font16W700BrandOnSecondary,
      ),
      AppGap.w(AppSize.p4),

      // Label
      Flexible(
        child: Text(
          label,
          maxLines: AppConstants.maxOneLine,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.font16W700Watermark,
        ),
      ),
    ],
  );
}
