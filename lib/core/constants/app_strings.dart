class AppStrings {
  const AppStrings._();

  // App
  static const String appName = 'سجّل';
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

  // Access control
  static const String accessCodeTitle = 'أدخل كود الوصول';
  static const String accessCodeSubtitle =
      'الكود الذي استلمته من المبرمج للوصول إلى البيانات';
  static const String accessCodeLabel = 'كود الوصول';
  static const String accessCodeRequired = 'أدخل الكود أولًا';
  static const String accessCodeInvalid = 'كود الوصول غير صالح';
  static const String accessCodeSubmit = 'دخول';

  // Local auth
  static const String localAuthResultCancelled = 'تم إلغاء التحقق';
  static const String localAuthResultUnavailable = 'التحقق من الجهاز غير متاح';
  static const String localAuthResultNotEnrolled =
      'لا يوجد بصمة أو PIN أو نمط مضبوط على الجهاز';
  static const String localAuthResultLockedOut =
      'التحقق مقفول مؤقتًا، حاول لاحقًا';
  static const String localAuthResultBusy = 'هناك طلب تحقق جارٍ بالفعل';
  static const String localAuthResultError = 'تعذّر التحقق، حاول مرة أخرى';

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
