import 'package:car_register/features/access_control/presentation/view_models/access_code_view_model.dart';
import 'package:flutter/material.dart';

class AccessCodeScope extends InheritedNotifier<AccessCodeViewModel> {
  const AccessCodeScope({
    super.key,
    required AccessCodeViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);

  static AccessCodeViewModel of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AccessCodeScope>();
    assert(scope != null, 'AccessCodeScope not found in context');
    return scope!.notifier!;
  }
}
