import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_icon_button.dart';
import 'package:car_register/core/widgets/app_text_field.dart';
import 'package:car_register/features/home/presentation/widgets/home_indexed_label.dart';
import 'package:flutter/material.dart';

class HomeHeaderContent extends StatelessWidget {
  const HomeHeaderContent({
    required this.numberController,
    required this.numberFocusNode,
    required this.onSave,
    required this.onSearch,
    super.key,
  });

  final TextEditingController numberController;
  final FocusNode numberFocusNode;
  final VoidCallback onSave;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Header row
      Row(
        children: [
          // App name
          Expanded(
            child: Text(
              AppStrings.appName,
              style: AppTextStyles.font20W700OnSecondary,
            ),
          ),

          // Search
          AppIconButton(
            icon: Icons.search,
            tooltip: AppStrings.brochuresSearchHint,
            color: AppColors.textOnSecondary,
            onPressed: onSearch,
          ),
        ],
      ),
      AppGap.h(AppSize.p12),

      // Indexed label
      const HomeIndexedLabel(
        index: AppStrings.homeHeaderIndex,
        label: AppStrings.homeEntryTitle,
      ),
      AppGap.h(AppSize.p16),

      // Input
      AppTextField(
        controller: numberController,
        focusNode: numberFocusNode,
        hint: AppStrings.homeSearchHint,
        onSubmitted: (_) => onSave(),
        keepKeyboardOpenOnSubmitted: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.send,
        autofocus: true,
        maxLength: AppConstants.brochureNumberMaxLength,
        inputFormatters: AppValidators.brochureNumberFormatters,

        // Save action
        trailing: ValueListenableBuilder<TextEditingValue>(
          valueListenable: numberController,
          builder: (context, value, _) => AppIconButton(
            icon: Icons.send_rounded,

            tooltip: AppStrings.saveNumber,
            color: AppColors.iconPrimary,
            onPressed: value.text.trim().isEmpty ? null : onSave,
          ),
        ),
        backgroundColor: AppColors.scaffoldBackgroundColor,
        borderColor: AppColors.textOnSecondary,
      ),
    ],
  );
}
