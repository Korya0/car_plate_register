import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';
import 'package:car_register/core/widgets/app_text_field.dart';
import 'package:car_register/features/access_control/presentation/scopes/access_code_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class AccessCodeForm extends StatefulWidget {
  const AccessCodeForm({super.key});

  @override
  State<AccessCodeForm> createState() => _AccessCodeFormState();
}

class _AccessCodeFormState extends State<AccessCodeForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    AccessCodeScope.of(context).clearError();
  }

  Future<void> _submit() async {
    final viewModel = AccessCodeScope.of(context);
    final code = _controller.text;
    final success = await viewModel.submit(code);

    if (!mounted) return;

    if (success) {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleTextChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = AccessCodeScope.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([viewModel, _controller]),
      builder: (context, child) {
        final canSubmit =
            _controller.text.trim().isNotEmpty && !viewModel.isLoading;

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
              autofocus: true,
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
              isLoading: viewModel.isLoading,
              expand: true,
            ).animate().slideX(
                  begin: 0.15,
                  end: 0,
                  duration: AppConstants.animationFast200ms,
                  delay: AppConstants.accessCodeStagger60ms * 6,
                  curve: Curves.easeOut,
                ),

            // Error Message
            if (viewModel.errorText != null) ...[
              AppGap.h(AppSize.p12),
              Text(
                viewModel.errorText!,
                style: AppTextStyles.font14W500Error,
              ).animate().fadeIn(
                    duration: AppConstants.animationFast200ms,
                    curve: Curves.easeOut,
                  ),
            ],
          ],
        );
      },
    );
  }
}
