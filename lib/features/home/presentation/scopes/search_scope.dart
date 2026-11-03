import 'package:car_register/features/home/presentation/view_models/search_view_model.dart';
import 'package:flutter/material.dart';

class SearchScope extends InheritedNotifier<SearchViewModel> {
  const SearchScope({
    super.key,
    required SearchViewModel notifier,
    required super.child,
  }) : super(notifier: notifier);

  static SearchViewModel of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SearchScope>();
    assert(scope != null, 'SearchScope not found in context');
    return scope!.notifier!;
  }
}
