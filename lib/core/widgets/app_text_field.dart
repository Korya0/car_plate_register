import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/theme/app_colors.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/utils/context_extension.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.hintText,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.keepKeyboardOpenOnSubmitted = false,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.leading,
    this.trailing,
    this.backgroundColor = AppColors.scaffoldBackgroundColor,
    this.borderColor = AppColors.dividerColor,
    this.focusedBorderColor = AppColors.borderBrand,
    this.textStyle,
    this.hintStyle,
    this.isDisabled = false,
    this.readOnly = false,
    this.onTap,
    this.hasError = false,
    this.highlightOnFocus = true,
    this.maxLines = AppConstants.maxOneLine,
    this.textDirection = TextDirection.ltr,
    this.textAlign = TextAlign.right,
  });

  final String? label;
  final String? hint;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool keepKeyboardOpenOnSubmitted;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final Widget? leading;
  final Widget? trailing;
  final Color backgroundColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final bool isDisabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool hasError;
  final bool highlightOnFocus;
  final int? maxLines;
  final TextDirection textDirection;
  final TextAlign textAlign;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) _internalFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      if (widget.focusNode == null) _internalFocusNode ??= FocusNode();
    }
  }

  @override
  void dispose() {
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle =
        widget.textStyle ??
        (widget.isDisabled
            ? AppTextStyles.font14W500Secondary
            : AppTextStyles.font14W500Primary);

    final hintStyle = widget.hintStyle ?? AppTextStyles.font14W500Secondary;
    final errorStyle = AppTextStyles.font12W500Error;
    final effectiveHint = widget.hint ?? widget.hintText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTextStyles.font14W700Primary),
          AppGap.h(AppSize.p8),
        ],

        // Field
        FormField<String>(
          initialValue: widget.controller?.text,
          validator: (value) {
            final current = widget.controller?.text ?? value;
            return widget.validator?.call(current);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListenableBuilder(
                listenable: _focusNode,
                builder: (context, _) {
                  final borderColor = widget.hasError || field.hasError
                      ? AppColors.primary
                      : _focusNode.hasFocus && widget.highlightOnFocus
                      ? widget.focusedBorderColor
                      : widget.borderColor;

                  return Container(
                    height: widget.maxLines == AppConstants.maxOneLine
                        ? AppSize.h48
                        : null,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(AppSize.r12),
                      border: Border.all(
                        color: borderColor,
                        width: AppSize.borderWidth,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (widget.leading != null) ...[
                          widget.leading!,
                          AppGap.w(AppSize.p8),
                        ],
                        Expanded(
                          child: TextField(
                            controller: widget.controller,
                            focusNode: _focusNode,
                            obscureText: widget.obscureText,
                            autofocus: widget.autofocus,
                            textDirection: widget.textDirection,
                            textAlign: widget.textAlign,
                            maxLines: widget.maxLines,
                            maxLength: widget.maxLength,
                            onChanged: (value) {
                              field.didChange(value);
                              widget.onChanged?.call(value);
                            },
                            onSubmitted: widget.onSubmitted,
                            onEditingComplete:
                                widget.keepKeyboardOpenOnSubmitted
                                ? () {}
                                : null,
                            inputFormatters: widget.inputFormatters,
                            keyboardType: widget.keyboardType,
                            textInputAction: widget.textInputAction,
                            enabled: !widget.isDisabled,
                            readOnly: widget.readOnly,
                            onTap: widget.onTap,
                            style: textStyle,
                            decoration: InputDecoration(
                              hintText: effectiveHint,
                              hintStyle: hintStyle,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              counterText: '',
                              isDense: true,

                              contentPadding: widget.leading == null
                                  ? EdgeInsets.symmetric(
                                      horizontal: AppSize.p16,
                                      vertical: AppSize.p12,
                                    )
                                  : EdgeInsets.symmetric(
                                      vertical: AppSize.p12,
                                    ),
                            ),
                          ),
                        ),
                        if (widget.trailing != null) ...[
                          AppGap.w(AppSize.p8),
                          widget.trailing!,
                        ],
                      ],
                    ),
                  );
                },
              ),
              // Error
              if (field.hasError) ...[
                AppGap.h(AppSize.p4),
                _FieldErrorText(
                  errorText: field.errorText!,
                  style: errorStyle,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldErrorText extends StatelessWidget {
  const _FieldErrorText({required this.errorText, required this.style});

  final String errorText;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return Text(errorText, style: style);

    return Text(errorText, style: style)
        .animate(key: ValueKey(errorText))
        .fadeIn(
          duration: AppConstants.animationFast200ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: AppConstants.slideOffsetSmall,
          end: AppConstants.slideOffsetNone,
          duration: AppConstants.animationFast200ms,
          curve: Curves.easeOut,
        );
  }
}
