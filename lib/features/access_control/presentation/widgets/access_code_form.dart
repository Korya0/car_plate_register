import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/router/app_routes.dart';
import 'package:car_register/core/theme/app_text_styles.dart';
import 'package:car_register/core/utils/app_logger.dart';
import 'package:car_register/core/utils/app_validators.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/core/widgets/app_primary_button.dart';
import 'package:car_register/core/widgets/app_text_field.dart';
import 'package:car_register/features/access_control/data/data_sources/access_control_remote_data_source.dart';
import 'package:car_register/features/access_control/data/repositories/access_control_repository_impl.dart';
import 'package:car_register/features/access_control/domain/use_cases/validate_access_code_use_case.dart';
import 'package:car_register/features/access_control/presentation/view_models/access_code_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late final AccessCodeViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    // Manual Dependency Injection
    final remoteDataSource = AccessControlRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );

    final repository = AccessControlRepositoryImpl(
      remoteDataSource: remoteDataSource,
      logger: const AppLogger(),
    );

    final useCase = ValidateAccessCodeUseCase(repository: repository);

    _viewModel = AccessCodeViewModel(
      verifyAccessCode: useCase,
    );

    _controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    _viewModel.clearError();
  }

  Future<void> _submit() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;

    final success = await _viewModel.submit(code);

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
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, textValue, child) {
            return ValueListenableBuilder<bool>(
              valueListenable: _viewModel.isLoading,
              builder: (context, isLoading, child) {
                final canSubmit =
                    textValue.text.trim().isNotEmpty && !isLoading;

                return AppPrimaryButton(
                  label: AppStrings.accessCodeSubmit,
                  onPressed: canSubmit ? _submit : null,
                  isLoading: isLoading,
                  expand: true,
                );
              },
            );
          },
        ).animate().slideX(
          begin: 0.15,
          end: 0,
          duration: AppConstants.animationFast200ms,
          delay: AppConstants.accessCodeStagger60ms * 6,
          curve: Curves.easeOut,
        ),

        // Error Message
        ValueListenableBuilder<String?>(
          valueListenable: _viewModel.errorText,
          builder: (context, errorText, child) {
            if (errorText == null) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppGap.h(AppSize.p12),
                Text(
                  errorText,
                  style: AppTextStyles.font14W500Error,
                ).animate().fadeIn(
                  duration: AppConstants.animationFast200ms,
                  curve: Curves.easeOut,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
