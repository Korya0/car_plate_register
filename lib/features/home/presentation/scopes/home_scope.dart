import 'package:car_register/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeScope extends InheritedNotifier<HomeViewModel> {
  const HomeScope({
    super.key,
    required HomeViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);

  static HomeViewModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<HomeScope>();
    assert(scope != null, 'HomeScope not found in context');
    return scope!.notifier!;
  }
}
