class AppStrings {
  const AppStrings._();

  // App
  static const String appName = 'Car Register';
  static const String appNameArabic = 'تسجيل السيارات';
  static const String pageNotFound = 'تعذّر فتح الصفحة';

  // Navigation
  static const String homeTab = 'الأرقام';
  static const String settingsTab = 'الإعدادات';
  static const String back = 'رجوع';

  // Home
  static const String homeTitle = 'أرقام البروشورات';
  static const String homeSubtitle = 'سجّل أرقام البروشورات وابحث عنها بسهولة';
  static const String addNumber = 'إضافة رقم';
  static const String searchHint = 'ابحث عن رقم';
  static const String emptyTitle = 'لا توجد أرقام';
  static const String emptyMessage = 'أضف أول رقم بروشور للبدء';

  // Settings
  static const String settingsTitle = 'الإعدادات';
  static const String generalSection = 'عام';
  static const String settingsPlaceholder = 'ستظهر إعدادات التطبيق هنا';

  // States
  static const String errorWidgetTitle = 'تعذّر إكمال العملية';
  static const String tryAgain = 'إعادة المحاولة';

  // Actions
  static const String save = 'حفظ';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String delete = 'حذف';
  static const String undo = 'تراجع';
  static const String search = 'بحث';

  // Brochure numbers
  static const String brochureNumberLabel = 'رقم البروشور';
  static const String brochureNumberHint = 'من 1 إلى 4 أرقام';
  static const String numberRequired = 'أدخل رقم البروشور';
  static const String numberDigitsOnly = 'يُسمح بالأرقام فقط';
  static const String numberLength = 'يجب أن يتكون الرقم من 1 إلى 4 أرقام';

  // Counters
  static String brochureCount(int count) => '$count رقم';
}
