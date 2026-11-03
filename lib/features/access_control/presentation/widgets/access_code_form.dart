import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';
import 'package:car_register/core/widgets/app_text_field.dart';
import 'package:car_register/features/access_control/presentation/view_models/access_code_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    context.read<AccessCodeViewModel>().clearError();
  }

  Future<void> _submit() async {
    final viewModel = context.read<AccessCodeViewModel>();
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
    return Consumer<AccessCodeViewModel>(
      builder: (context, viewModel, child) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final canSubmit = _controller.text.trim().isNotEmpty &&
                viewModel.state != AccessCodeState.loading;

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
                  isLoading: viewModel.state == AccessCodeState.loading,
                  expand: true,
                ).animate().slideX(
                      begin: 0.15,
                      end: 0,
                      duration: AppConstants.animationFast200ms,
                      delay: AppConstants.accessCodeStagger60ms * 6,
                      curve: Curves.easeOut,
                    ),

                // Error Message
                if (viewModel.state == AccessCodeState.failure &&
                    viewModel.errorMessage != null) ...[
                  AppGap.h(AppSize.p12),
                  Text(
                    viewModel.errorMessage!,
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
      },
    );
  }
}
