import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/widgets/app_pressable.dart';
import 'package:car_register/features/home/domain/entities/brochure_entity.dart';
import 'package:flutter/material.dart';

class HomeBrochureEntryRow extends StatelessWidget {
  const HomeBrochureEntryRow({
    required BrochureEntity brochure,
    required String query,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    bool isSelecting = false,
    bool isSelected = false,
    Key? key,
  }) : this._(
         brochure: brochure,
         query: query,
         onPressed: onPressed,
         onLongPress: onLongPress,
         isSelecting: isSelecting,
         isSelected: isSelected,
         isLoading: false,
         key: key,
       );

  const HomeBrochureEntryRow.loading({Key? key})
    : this._(
        brochure: null,
        query: '',
        onPressed: null,
        onLongPress: null,
        isSelecting: false,
        isSelected: false,
        isLoading: true,
        key: key,
      );

  const HomeBrochureEntryRow._({
    required this.brochure,
    required this.query,
    required this.onPressed,
    required this.onLongPress,
    required this.isSelecting,
    required this.isSelected,
    required this.isLoading,
    super.key,
  });

  final BrochureEntity? brochure;
  final String query;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isSelecting;
  final bool isSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final entry = brochure;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.surfaceSelected : null,
        border: Border.all(
          color: isSelected ? AppColors.borderBrand : AppColors.dividerColor,
          width: AppSize.borderWidth,
        ),
        borderRadius: BorderRadius.circular(AppSize.r12),
      ),
      // Border stays solid; only the card content fades when pressed.
      child: AppPressable(
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: Stack(
          children: [
            // Number
            Padding(
              padding: EdgeInsets.all(AppSize.p8),
              child: Center(
                child: isLoading
                    ? _HomeBrochureRowPlaceholder(
                        text: List<String>.filled(
                          AppConstants.brochureNumberMaxLength,
                          '0',
                        ).join(),
                        style: AppTextStyles.font14W700Primary,
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text.rich(
                          _highlightedNumber(entry!),
                          maxLines: AppConstants.maxOneLine,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
              ),
            ),

            // Selection (corner overlay; the card content keeps its size)
            if (isSelecting)
              PositionedDirectional(
                top: AppSize.p4,
                start: AppSize.p4,
                child: Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: AppSize.icon16,
                  color: isSelected
                      ? AppColors.iconPrimary
                      : AppColors.iconDisabled,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Highlights matching digits.
  TextSpan _highlightedNumber(BrochureEntity brochure) {
    final baseStyle = AppTextStyles.font14W700Primary;
    if (query.isEmpty) return TextSpan(text: brochure.number, style: baseStyle);

    final matchIndex = brochure.number.indexOf(query);
    if (matchIndex < 0) {
      return TextSpan(text: brochure.number, style: baseStyle);
    }

    final matchEnd = matchIndex + query.length;
    return TextSpan(
      children: [
        if (matchIndex > 0)
          TextSpan(
            text: brochure.number.substring(0, matchIndex),
            style: baseStyle,
          ),
        TextSpan(
          text: brochure.number.substring(matchIndex, matchEnd),
          style: AppTextStyles.font14W700Brand,
        ),
        if (matchEnd < brochure.number.length)
          TextSpan(
            text: brochure.number.substring(matchEnd),
            style: baseStyle,
          ),
      ],
    );
  }
}

class _HomeBrochureRowPlaceholder extends StatelessWidget {
  const _HomeBrochureRowPlaceholder({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      maxLines: AppConstants.maxOneLine,
    )..layout();

    return Container(
      width: textPainter.width,
      height: textPainter.height,
      decoration: BoxDecoration(
        color: AppColors.surfaceDisabled,
        borderRadius: BorderRadius.circular(AppSize.r8),
      ),
    );
  }
}
