import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_icon_button.dart';
import 'package:car_register/core/widgets/app_text_field.dart';
import 'package:car_register/features/home/presentation/widgets/home_indexed_label.dart';
import 'package:flutter/material.dart';

class SearchHeaderContent extends StatelessWidget {
  const SearchHeaderContent({
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
    required this.onSubmit,
    required this.onBack,
    super.key,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // Header row
      Row(
        children: [
          // Back
          AppIconButton(
            icon: Icons.arrow_back_ios_new,
            tooltip: AppStrings.back,
            color: AppColors.textOnSecondary,
            size: AppSize.icon20,
            onPressed: onBack,
          ),

          const Spacer(),
        ],
      ),
      AppGap.h(AppSize.p12),

      // Indexed label
      const HomeIndexedLabel(
        index: AppStrings.brochuresHeaderIndex,
        label: AppStrings.allBrochuresTitle,
      ),
      AppGap.h(AppSize.p16),

      // Search input
      AppTextField(
        controller: searchController,
        focusNode: searchFocusNode,
        autofocus: true,
        hint: AppStrings.brochuresSearchHint,
        onChanged: onSearchChanged,
        onSubmitted: (_) => onSubmit(),
        keepKeyboardOpenOnSubmitted: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.search,
        maxLength: AppConstants.brochureNumberMaxLength,
        inputFormatters: AppValidators.brochureNumberFormatters,
        trailing: ValueListenableBuilder<TextEditingValue>(
          valueListenable: searchController,
          builder: (context, value, _) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Clear
              if (value.text.isNotEmpty)
                AppIconButton(
                  icon: Icons.close,
                  tooltip: AppStrings.clearSearch,
                  color: AppColors.iconSecondary,
                  onPressed: () {
                    searchController.clear();
                    onSearchChanged('');
                  },
                ),

              // Submit
              AppIconButton(
                icon: Icons.send_rounded,
                tooltip: AppStrings.searchNow,
                color: AppColors.iconPrimary,
                onPressed: value.text.trim().isEmpty ? null : onSubmit,
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.scaffoldBackgroundColor,
        borderColor: AppColors.textOnSecondary,
      ),
    ],
  );
}
