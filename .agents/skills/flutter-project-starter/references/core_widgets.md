# Core Flat Widgets Blueprint

All shared widgets in any generated project live **flat** directly inside `lib/core/widgets/` without subdirectories. They depend exclusively on `AppSize`, `AppColors`, `AppConstants`, and `AppPressable`.

---

## 1. Interaction & Spacing (`app_gap.dart`, `app_divider.dart`, `app_pressable.dart`)

### `app_gap.dart`
```dart
import 'package:flutter/widgets.dart';

class AppGap extends StatelessWidget {
  const AppGap.h(this.size, {super.key}) : isVertical = true;
  const AppGap.w(this.size, {super.key}) : isVertical = false;

  final double size;
  final bool isVertical;

  @override
  Widget build(BuildContext context) => isVertical ? SizedBox(height: size) : SizedBox(width: size);
}
```

### `app_pressable.dart`
Sole owner of touch interactions — opacity fade to `0.55` without splash ripple:
```dart
import 'package:flutter/widgets.dart';
import 'package:{{APP_PACKAGE}}/core/constants/app_constants.dart';

class AppPressable extends StatefulWidget {
  const AppPressable({
    required this.child,
    this.onPressed,
    this.fadeOpacity = AppConstants.opacityPressed,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double fadeOpacity;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onPressed,
      onTapDown: enabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedOpacity(
        duration: _isPressed ? AppConstants.pressFadeIn70ms : AppConstants.pressFadeOut150ms,
        opacity: !enabled ? AppConstants.opacityDisabled : (_isPressed ? widget.fadeOpacity : AppConstants.opacityFull),
        child: widget.child,
      ),
    );
  }
}
```

### `app_divider.dart`
```dart
import 'package:flutter/material.dart';
import 'package:{{APP_PACKAGE}}/core/constants/app_sizes.dart';
import 'package:{{APP_PACKAGE}}/core/theme/app_colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({this.color, this.thickness, super.key});
  final Color? color;
  final double? thickness;

  @override
  Widget build(BuildContext context) => Divider(
    color: color ?? AppColors.dividerColor,
    thickness: thickness ?? AppSize.dividerThickness,
    height: AppSize.dividerHeight,
  );
}
```

---

## 2. Buttons (`app_primary_button.dart`, `app_secondary_button.dart`, `app_text_button.dart`, `app_icon_button.dart`)

- **`AppPrimaryButton`:** Background `AppColors.primary`, text `AppColors.textOnPrimary`, height `AppSize.h48`, built-in `isLoading` state.
- **`AppSecondaryButton`:** Background `AppColors.secondary` or outline with transparent fill, height `AppSize.h48`.
- **`AppTextButton`:** Transparent text-only button utilizing `AppPressable`.
- **`AppIconButton`:** Enforces the minimum 48×48 px touch target (`AppConstants.minTapTarget`).

---

## 3. Inputs (`app_text_field.dart`)

- Built upon `TextFormField` styled to match the dark or light surface colors.
- Background `AppColors.secondaryScaffoldBackgroundColor`, border radius `AppSize.r12`, border `AppColors.dividerColor`.
- Supports `prefixIcon`, `suffixIcon`, `validator`, `keyboardType`, `inputFormatters`, `maxLines`.

---

## 4. State Views (`app_empty_view.dart`, `app_error_view.dart`)

- **`AppEmptyView`:** Large illustrative icon, title `font16W700Primary`, subtitle `font14W500Secondary`, optional CTA button.
- **`AppErrorView`:** Displays error message with retry action button (`onRetry`).

---

## 5. Slivers & Scrolling (`common_sliver_app_bar.dart`, `app_sliver_list.dart`, `app_sliver_grid.dart`)

- **`CommonSliverAppBar`:** Pinned sliver app bar with zero elevation and centered title.
- **`AppSliverList`:** Wraps `SliverList.builder` with padding.
- **`AppSliverGrid`:** Wraps `SliverGrid.extent` or `SliverGrid.count`.

---

## 6. Overlays (`app_bottom_sheet.dart`, `custom_confirmation_dialog.dart`, `app_toast.dart`)

- **`AppBottomSheet`:** Bottom sheet with top rounded corners `AppSize.r24` and drag handle.
- **`CustomConfirmationDialog`:** Modal dialog requesting user confirmation before destructive actions.
- **`AppToast`:** Floating toast notification via `SnackBar` with 2-second timeout.

---

## 7. App Shell & Navigation (`app_bottom_nav_bar.dart`, `bottom_nav_tab_config.dart`, `main_view.dart`)

- **`BottomNavTabConfig`:** Holds icon, title, and path for each bottom tab.
- **`AppBottomNavBar`:** Custom navigation bar styled with active tab indicators.
- **`MainView`:** Stateful shell view coordinating bottom tab switching.
