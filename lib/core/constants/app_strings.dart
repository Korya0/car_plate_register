class AppStrings {
  const AppStrings._();

  // App
  static const String appName = 'سجّل';
  static const String pageNotFound = 'تعذّر فتح الصفحة';

  // Navigation
  static const String back = 'رجوع';

  // Home
  static const String homeHeaderWatermark = '#';
  static const String brochuresHeaderWatermark = 'LIST';
  static const String homeHeaderIndex = '01';
  static const String brochuresHeaderIndex = '02';
  static const String homeEntryTitle = 'أدخل رقم البروشور';
  static const String allBrochuresTitle = 'كل الأرقام المسجلة';
  static const String headerSlash = '/';
  static const String homeSearchHint = 'أدخل رقم البروشور';
  static const String brochuresSearchHint = 'ابحث عن رقم بروشور';
  static const String clearSearch = 'مسح البحث';
  static const String moreOptions = 'خيارات إضافية';
  static const String deleteBrochure = 'حذف البروشور';
  static const String deleteAll = 'حذف الكل';
  static const String noBrochuresYet = 'لا توجد أرقام بعد';
  static const String emptyCount = '000';
  static const String firstBrochurePrompt = 'ابدأ بتسجيل أول رقم بروشور.';
  static const String addFirstBrochure = 'سجّل أول رقم';
  static const String deleteBrochureTitle = 'حذف البروشور؟';
  static const String deleteAllTitle = 'حذف كل البروشورات؟';
  static String deleteBrochureMessage(String number) =>
      'سيتم حذف الرقم $number من القائمة.';
  static const String deleteAllMessage = 'سيتم حذف جميع الأرقام من القائمة.';
  static String deletedMessage(String number) => 'تم حذف $number';
  static const String allDeletedMessage = 'تم حذف جميع الأرقام';
  static const String brochureDuplicateTitle = 'الرقم مسجّل مسبقًا';
  static const String brochureDuplicateMessage =
      'هذا الرقم موجود بالفعل في قائمة البروشورات.';
  static const String brochureInputErrorTitle = 'تعذّر إدخال الرقم';
  static String addedAt(String time) => 'اليوم $time';
  static String time(String hour, String minute) => '$hour:$minute';
  static const String placeholderTime = '00:00';

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

  // States
  static const String emptyTitle = 'لا توجد أرقام';
  static const String errorWidgetTitle = 'تعذّر إكمال العملية';
  static const String tryAgain = 'إعادة المحاولة';

  // Actions
  static const String cancel = 'إلغاء';
  static const String delete = 'حذف';
  static const String undo = 'تراجع';
  static const String okay = 'حسنًا';

  // Brochure numbers
  static const String numberRequired = 'أدخل رقم البروشور';
  static const String numberDigitsOnly = 'يُسمح بالأرقام فقط';
  static const String numberLength = 'يجب أن يتكون الرقم من 1 إلى 4 أرقام';
}
