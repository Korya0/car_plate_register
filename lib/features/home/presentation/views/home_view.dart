import 'package:flutter/material.dart';

import 'package:car_register/core/constants/app_strings.dart';
import 'package:car_register/core/widgets/app_page_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppPageHeader(
            watermarkText: AppStrings.homeHeaderWatermark,
          ),
        ),
      ],
    ),
  );
}
