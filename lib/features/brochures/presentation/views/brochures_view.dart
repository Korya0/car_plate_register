import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/widgets/app_page_header.dart';

class BrochuresView extends StatelessWidget {
  const BrochuresView({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    key: Key('brochures-view'),
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppPageHeader(
            watermarkText: AppStrings.brochuresHeaderWatermark,
          ),
        ),
      ],
    ),
  );
}
