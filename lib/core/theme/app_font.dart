import 'package:flutter/material.dart';

abstract final class AppFont {
  AppFont._();

  static const String family = 'Cairo';
}

enum AppFontWeight {
  regular(FontWeight.w400),
  medium(FontWeight.w500),
  bold(FontWeight.w700),
  extraBold(FontWeight.w800);

  const AppFontWeight(this.value);

  final FontWeight value;
}
