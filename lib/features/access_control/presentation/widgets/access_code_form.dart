import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/di/app_providers.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';
import 'package:car_register/core/widgets/app_text_field.dart';
import 'package:car_register/features/access_control/presentation/providers/access_control_notifier.dart';

class AccessCodeForm extends ConsumerStatefulWidget {
  const AccessCodeForm({super.key});

  @override
  ConsumerState<AccessCodeForm> createState() => _AccessCodeFormState();
}

class _AccessCodeFormState extends ConsumerState<AccessCodeForm> {
  final TextEditingController _controller = TextEditingController();

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

  void _handleChanged() =>
      ref.read(accessCodeNotifierProvider.notifier).clearError();

  Future<void> _submit() async {
    if (_controller.text.trim().isEmpty) return;

    await ref
        .read(accessCodeNotifierProvider.notifier)
        .validate(_controller.text.trim());

    if (!mounted) return;

    final state = ref.read(accessCodeNotifierProvider);
    if (state.accessCode != null) {
      ref.read(accessCodeProvider.notifier).save(_controller.text.trim());
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accessCodeNotifierProvider);
    final canSubmit = _controller.text.trim().isNotEmpty && !state.isLoading;

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
          isLoading: state.isLoading,
          expand: true,
        ).animate().slideX(
          begin: 0.15,
          end: 0,
          duration: AppConstants.animationFast200ms,
          delay: AppConstants.accessCodeStagger60ms * 6,
          curve: Curves.easeOut,
        ),

        // Error
        if (state.error != null) ...[
          AppGap.h(AppSize.p12),
          Text(
            state.error!,
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
