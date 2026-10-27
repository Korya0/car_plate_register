import 'package:car_register/core/constants/app_sizes.dart';
import 'package:car_register/core/widgets/app_gap.dart';
import 'package:car_register/features/access_control/presentation/widgets/access_code_form.dart';
import 'package:car_register/features/access_control/presentation/widgets/access_code_header.dart';
import 'package:flutter/material.dart';

class AccessCodeView extends StatelessWidget {
  const AccessCodeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverSafeArea(
          bottom: false,
          sliver: SliverPadding(
            padding: EdgeInsets.only(
              top: AppSize.stp,
              left: AppSize.p16,
              right: AppSize.p16,
            ),
            sliver: SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSize.contentMaxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const AccessCodeHeader(),

                    AppGap.h(AppSize.p32),

                    // Form
                    const AccessCodeForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: AppGap.h(AppSize.sbp)),
      ],
    ),
  );
}
