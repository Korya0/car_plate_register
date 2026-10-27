import 'package:flutter_test/flutter_test.dart';

import 'package:car_register/core/theme/app_font.dart';
import 'package:car_register/core/theme/app_theme.dart';

void main() {
  test('uses Cairo as the only font family', () {
    expect(AppFont.family, 'Cairo');
    expect(AppTheme.theme.textTheme.bodyMedium?.fontFamily, AppFont.family);
    expect(AppTheme.theme.textTheme.titleLarge?.fontFamily, AppFont.family);
  });
}
