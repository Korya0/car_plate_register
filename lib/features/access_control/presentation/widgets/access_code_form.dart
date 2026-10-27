import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';
import 'package:car_register/core/widgets/app_text_field.dart';

class AccessCodeForm extends StatefulWidget {
  const AccessCodeForm({super.key});

  @override
  State<AccessCodeForm> createState() => _AccessCodeFormState();
}

class _AccessCodeFormState extends State<AccessCodeForm> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleChanged)
      ..dispose();
    super.dispose();
  }

  void _handleChanged() => setState(() => _errorText = null);

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    await Future<void>.delayed(AppConstants.animationSlower500ms);

    if (!mounted) return;

    if (_controller.text.trim() == AppConstants.accessCodeDemoValue) {
      context.go(AppRoutes.home);
      return;
    }

    setState(() {
      _isLoading = false;
      _errorText = AppStrings.accessCodeInvalid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _controller.text.trim().isNotEmpty && !_isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          AppStrings.accessCodeLabel,
          style: AppTextStyles.font13W400Secondary,
        ).animate().slideX(
          begin: 0.15,
          end: 0,
          duration: AppConstants.animationFast200ms,
          delay: AppConstants.accessCodeStagger60ms * 4,
          curve: Curves.easeOut,
        ),

        AppGap.h(AppSize.p8),

        // Field
        AppTextField(
          controller: _controller,
          validator: AppValidators.accessCode,
          keyboardType: TextInputType.visiblePassword,
          inputFormatters: AppValidators.accessCodeFormatters,
        ).animate().slideX(
          begin: 0.15,
          end: 0,
          duration: AppConstants.animationFast200ms,
          delay: AppConstants.accessCodeStagger60ms * 5,
          curve: Curves.easeOut,
        ),

        AppGap.h(AppSize.p16),

        // Submit
        AppPrimaryButton(
          label: AppStrings.accessCodeSubmit,
          onPressed: canSubmit ? _submit : null,
          isLoading: _isLoading,
          expand: true,
        ).animate().slideX(
          begin: 0.15,
          end: 0,
          duration: AppConstants.animationFast200ms,
          delay: AppConstants.accessCodeStagger60ms * 6,
          curve: Curves.easeOut,
        ),

        // Error
        if (_errorText != null) ...[
          AppGap.h(AppSize.p12),
          Text(
            _errorText!,
            style: AppTextStyles.font14W500Error,
          ).animate().fadeIn(
            duration: AppConstants.animationFast200ms,
            curve: Curves.easeOut,
          ),
        ],
      ],
    );
  }
}
