# Car Register — مراحل التنفيذ والتشيك ليست (Updated Progress Roadmap)

**المرجع:** `docs/PROJECT_SPECIFICATION.md` (v1.3)  
**تاريخ التحديث:** 2026-11-08  
**الحالة:** تطوير الخطة الأصلية وإضافة تحديات هندسية وميزات جديدة.

## الرموز

- [x] مكتمل — مطبق فعليًا.
- [ ] غير منفذ — مهمة مستقبلية.
- [ ] 🆕 إضافة جديدة — Feature أو Engineering Challenge مضافة للخطة.

---

## ✅ المرحلة 1 — الإعداد والتأسيس

- [x] إعداد `pubspec.yaml` كامل: Riverpod, go_router, Firebase (core + Firestore), flutter_secure_storage, local_auth, mocktail/flutter_lints.
- [x] package name: `com.korya0.car_register` + versioning.
- [x] Theme (Light Material3) + Cairo Font.
- [x] Assets + fonts + native splash.
- [x] Lint rules عبر `analysis_options.yaml`.
- [x] Firebase Android configuration.
- [x] `.firebaserc`.
- [x] توحيد Firebase Project بين `.firebaserc` و`google-services.json`.
- [x] إزالة CLI scaffolding غير المستخدم (`firebase.json`, `firestore.indexes.json`).

## ✅ المرحلة 2 — البنية الأساسية (Core)

- [x] Feature-First Clean Architecture: `domain/` + `data/` + `presentation/`.
- [x] Error & Result System: `Result` + `Failure`.
- [x] Dependency Injection باستخدام Riverpod.
- [x] Unified Routing باستخدام go_router.
- [x] Shared Widgets في `core/widgets/`.
- [x] AppLogger + AppProviderObserver.
- [x] Centralized Validators.
- [x] Architecture Documentation.
- [x] الحفاظ على Riverpod كحل State Management الحالي دون تغييره.

## 🟡 المرحلة 3 — أرقام البروشورات (Brochure Numbers)

### الوظائف الأساسية

- [x] إضافة رقم وحفظه في Firestore.
- [x] Validation: من 1 إلى 4 أرقام.
- [x] الاحتفاظ بالأصفار البادئة مثل `007`.
- [x] عرض الأرقام مع وقت الإضافة.
- [x] البحث عن الأرقام.
- [x] حذف رقم مع التأكيد.
- [x] Multi-Selection + Bulk Delete.
- [x] عرض عدد الأرقام المسجلة.

### A. Advanced Search

- [ ] 🆕 Advanced Search — تطوير البحث ليعتمد على أكثر من معيار.
- [ ] 🆕 البحث برقم البروشور.
- [ ] 🆕 البحث بتاريخ الإضافة.
- [ ] 🆕 البحث باستخدام نطاق زمني (From Date – To Date).
- [ ] 🆕 الجمع بين أكثر من معيار في عملية بحث واحدة.
- [ ] 🆕 دعم شروط AND / OR عند الحاجة.
- [ ] 🆕 تصميم Search Logic قابلة للتوسع دون ربطها بالـ UI.

### B. Search History

- [ ] 🆕 الاحتفاظ بعمليات البحث السابقة.
- [ ] 🆕 إعادة تنفيذ عملية بحث سابقة.
- [ ] 🆕 حذف عنصر من سجل البحث.
- [ ] 🆕 مسح سجل البحث بالكامل.
- [ ] 🆕 تحديد مكان تخزين سجل البحث محليًا.

### C. Recently Added / Modified

- [ ] 🆕 عرض أحدث السجلات إضافة.
- [ ] 🆕 عرض أحدث السجلات تعديلًا.
- [ ] 🆕 إضافة `updatedAt` إلى نموذج السجل.
- [ ] 🆕 ترتيب السجلات حسب وقت الإضافة أو آخر تعديل.

### D. Recycle Bin

- [ ] 🆕 إنشاء Recycle Bin للاحتفاظ بالسجلات المحذوفة.
- [ ] 🆕 نقل السجل إلى سلة المحذوفات بدل الحذف النهائي مباشرة.
- [ ] 🆕 عرض السجلات المحذوفة في شاشة مستقلة.
- [ ] 🆕 استعادة سجل محذوف (Restore).
- [ ] 🆕 الحذف النهائي لسجل محدد.
- [ ] 🆕 حذف جميع السجلات من سلة المحذوفات.
- [ ] 🆕 الاحتفاظ بتاريخ الحذف `deletedAt`.
- [ ] 🆕 تحديد سياسة الاحتفاظ بالسجلات المحذوفة.
- [ ] 🆕 دعم استعادة السجلات مع المزامنة بين الأجهزة.

## 🟡 المرحلة 4 — مشاركة البيانات (Shared Access PIN)

### الوظائف الحالية

- [x] شاشة إدخال Access Code.
- [x] Validation للكود.
- [x] التحقق من الكود مقابل Firestore.
- [x] الاعتماد على `isActive`.
- [x] إدخال الكود عند ربط الجهاز.
- [x] انتهاء أو إبطال الكود وإعادة التوجيه إلى شاشة إدخال الكود.
- [x] عدم وجود تسجيل دخول Email/Password أو إدارة الأكواد داخل التطبيق.

### A. Shared Access Security

- [ ] 🆕 Rate Limiting — تحديد معدل محاولات إدخال Access Code.
- [ ] 🆕 Temporary Lockout — إيقاف المحاولات مؤقتًا بعد عدد محدد من المحاولات الفاشلة.
- [ ] 🆕 Access Code Expiration — تحديد مدة صلاحية الكود.
- [ ] 🆕 Server-Side Validation — تنفيذ التحقق والعمليات الحساسة من خلال Cloud Functions عند الحاجة.
- [ ] 🆕 منع تخمين Access Code عن طريق المحاولات المتكررة.
- [ ] 🆕 التعامل مع انتهاء صلاحية الكود أثناء استخدام التطبيق.

### B. Device Management

- [ ] 🆕 Device Registration — تسجيل الأجهزة المصرح لها باستخدام Access Code.
- [ ] 🆕 Device Identification — إنشاء هوية موثوقة لكل جهاز مرتبط.
- [ ] 🆕 Device Revocation — إلغاء صلاحية جهاز محدد.
- [ ] 🆕 منع الجهاز الملغى من تنفيذ عمليات جديدة.
- [ ] 🆕 ربط صلاحية الجهاز بحالة Access Code.
- [ ] 🆕 Device Management Screen — شاشة لإدارة الأجهزة المرتبطة.

### C. Access Audit Log

- [ ] 🆕 تسجيل محاولات إدخال Access Code.
- [ ] 🆕 تسجيل عمليات ربط الأجهزة.
- [ ] 🆕 تسجيل عمليات إلغاء صلاحية الأجهزة.
- [ ] 🆕 تسجيل العمليات الأمنية المهمة.
- [ ] 🆕 حفظ وقت ونوع العملية والجهاز المرتبط بها.
- [ ] 🆕 عرض سجل النشاط الأمني عند الحاجة.

## ❌ المرحلة 5 — العمل أوفلاين والمزامنة (Offline-First & Data Synchronization)

### A. Local Database

- [ ] 🆕 إضافة Drift + SQLite.
- [ ] 🆕 تصميم Local Database Schema.
- [ ] 🆕 إنشاء Local Data Source.
- [ ] 🆕 إنشاء Database Migrations.
- [ ] 🆕 ربط Local Data Source بالـ Repository.
- [ ] 🆕 تحديد استراتيجية تخزين البيانات محليًا.
- [ ] 🆕 دعم تخزين السجلات النشطة والمحذوفة محليًا.

### B. Offline-First Architecture

- [ ] 🆕 تطبيق Offline-First Architecture.
- [ ] 🆕 اعتماد Local Database كمصدر قراءة أساسي (Local Source of Truth).
- [ ] 🆕 عرض البيانات دون الحاجة لاتصال بالإنترنت.
- [ ] 🆕 تنفيذ عمليات الإضافة محليًا.
- [ ] 🆕 تنفيذ عمليات التعديل محليًا.
- [ ] 🆕 تنفيذ عمليات الحذف محليًا.
- [ ] 🆕 تحديث الواجهة مباشرة بعد العمليات المحلية.
- [ ] 🆕 دعم البحث والفلترة أثناء عدم الاتصال.

### C. Synchronization Engine

- [ ] 🆕 إنشاء Sync Service مستقل.
- [ ] 🆕 إنشاء Pending Operations Queue / Outbox.
- [ ] 🆕 تسجيل العمليات التي تنتظر المزامنة.
- [ ] 🆕 مزامنة البيانات عند عودة الاتصال.
- [ ] 🆕 Background Synchronization.
- [ ] 🆕 Manual Sync.
- [ ] 🆕 Pull to Refresh.
- [ ] 🆕 تحديد ترتيب تنفيذ العمليات المتراكمة.
- [ ] 🆕 معالجة فشل المزامنة دون فقد البيانات.
- [ ] 🆕 Sync Status لكل سجل: Synced / Pending / Failed.

### D. Reliability & Retry

- [ ] 🆕 Retry Mechanism.
- [ ] 🆕 Exponential Backoff.
- [ ] 🆕 تحديد عدد محاولات إعادة التنفيذ.
- [ ] 🆕 Idempotent Operations — منع تكرار تأثير العملية عند إعادة إرسالها.
- [ ] 🆕 ضمان عدم تكرار السجلات نتيجة إعادة المحاولة.
- [ ] 🆕 التعامل مع العمليات الفاشلة التي تحتاج تدخلًا إضافيًا.

### E. Conflict Resolution

- [ ] 🆕 تصميم Conflict Resolution Strategy.
- [ ] 🆕 اكتشاف تعارض التعديلات بين الأجهزة.
- [ ] 🆕 تحديد سياسة التعامل مع تعديل نفس السجل من جهازين.
- [ ] 🆕 تحديد سياسة التعامل مع حذف سجل أثناء تعديله على جهاز آخر.
- [ ] 🆕 تحديد أولوية العمليات المتعارضة.
- [ ] 🆕 ضمان اتساق البيانات بين الأجهزة بعد المزامنة.

### F. Soft Delete & Tombstones

- [ ] 🆕 تطبيق Soft Delete بدل الحذف النهائي المباشر.
- [ ] 🆕 إضافة `isDeleted` و`deletedAt`.
- [ ] 🆕 الاحتفاظ بمعلومات الحذف أثناء المزامنة.
- [ ] 🆕 منع ظهور السجلات المحذوفة مجددًا على الأجهزة الأخرى.
- [ ] 🆕 دعم Restore من Recycle Bin.
- [ ] 🆕 تصميم آلية الحذف النهائي بعد انتهاء سياسة الاحتفاظ.
- [ ] 🆕 التعامل مع Tombstones أثناء المزامنة بين الأجهزة.

## 🟡 المرحلة 6 — قفل التطبيق (App Lock)

### الوظائف الحالية

- [x] Local Auth Service.
- [x] Local Auth Result Handling.
- [x] `runWithLocalAuth` Guard.
- [x] فحص `isDeviceSupported()`.
- [x] Fallback لاعتمادات الجهاز PIN / Pattern / Biometrics.
- [x] Unit Tests للخدمة والـ Guard.

### A. Sensitive Screen Protection

- [ ] 🆕 Secure Sensitive Screens — حماية الشاشات الحساسة من الظهور بمحتواها في Recent Apps.
- [ ] 🆕 Screenshot Protection — منع التقاط Screenshots للشاشات الحساسة على Android.
- [ ] 🆕 تحديد الشاشات التي تحتاج إلى الحماية.
- [ ] 🆕 تطبيق الحماية عند دخول الشاشة.
- [ ] 🆕 إزالة الحماية عند مغادرة الشاشة عند الحاجة.
- [ ] 🆕 التأكد من عدم تسرب البيانات الحساسة في App Switcher.

**ملاحظة:** لا نعيد تنفيذ Automatic App Lock أو Lock Timeout أو Authentication on Resume باعتبارها Features جديدة إذا كانت بالفعل مغطاة بالسلوك الحالي؛ المصادقة نفسها تظل عبر `local_auth`.

## 🟡 المرحلة 8 — واجهة الاستخدام (UI/UX)

### الوظائف الحالية

- [x] واجهة عربية بالكامل.
- [x] RTL.
- [x] Light Material3 Theme.
- [x] Home Screen.
- [x] Search Screen.
- [x] Confirmation Dialogs.
- [x] Skeleton Loading.
- [x] Empty States.
- [x] Error Views.
- [x] Keyboard Handling.
- [x] Edge-to-Edge.

### تطويرات الواجهة الجديدة

- [ ] 🆕 شاشة Recycle Bin.
- [ ] 🆕 واجهة Advanced Search.
- [ ] 🆕 عرض Search History.
- [ ] 🆕 عرض Recently Added / Modified.
- [ ] 🆕 عرض حالة الاتصال بالإنترنت.
- [ ] 🆕 عرض Sync Status.
- [ ] 🆕 عرض العمليات التي تنتظر المزامنة.
- [ ] 🆕 واجهة التعامل مع فشل المزامنة.
- [ ] 🆕 واجهة Device Management.
- [ ] 🆕 عرض تفاصيل الأجهزة المرتبطة.
- [ ] 🆕 واجهة Access Audit Log عند الحاجة.

## 🟡 المرحلة 9 — قاعدة البيانات والأمان (DB & Security)

### الوظائف الحالية

- [x] Brochure Entity / Model.
- [x] تخزين رقم البروشور كـ String.
- [x] Firestore Collection Structure.
- [x] Firestore Security Rules.
- [x] تقييد الكتابة بوجود Access Code فعال.
- [x] التعامل مع Access Code غير الصالح.
- [x] عدم تخزين مفاتيح إدارة سرية داخل التطبيق.

### A. Data Integrity

- [ ] 🆕 تحديث Data Model لدعم `updatedAt`.
- [ ] 🆕 تحديث Data Model لدعم `deletedAt` و`isDeleted`.
- [ ] 🆕 إضافة Metadata اللازمة للمزامنة.
- [ ] 🆕 تحديد معرفات ثابتة للسجلات بين Local DB وFirestore.
- [ ] 🆕 تحديد Version أو Revision للبيانات عند الحاجة.
- [ ] 🆕 ضمان اتساق نموذج البيانات المحلي والسحابي.
- [ ] 🆕 Database Migration Strategy.
- [ ] 🆕 مراجعة Integrity بعد عمليات المزامنة.

### B. Firestore Security

- [ ] 🆕 مراجعة وتطوير Firestore Security Rules مع الميزات الجديدة.
- [ ] 🆕 حماية عمليات Recycle Bin والاستعادة والحذف النهائي.
- [ ] 🆕 حماية بيانات الأجهزة المرتبطة.
- [ ] 🆕 حماية Access Audit Logs.
- [ ] 🆕 التأكد من عدم قدرة الأجهزة الملغاة على تنفيذ عمليات.
- [ ] 🆕 تطبيق Server-Side Validation للعمليات التي لا يمكن تأمينها بقواعد Firestore وحدها.
- [ ] 🆕 مراجعة صلاحيات القراءة والكتابة لكل عملية.

## 🟡 المرحلة 10 — الاختبارات (Testing)

### الاختبارات الحالية

- [x] Validators Tests.
- [x] Repository Tests.
- [x] Home View Tests.
- [x] Search View Tests.
- [x] Access Code Tests.
- [x] Validate Access Code Use Case Tests.
- [x] Local Auth Service Tests.
- [x] Local Auth Guard Tests.
- [x] Widget Tests.
- [x] Result Semantics Tests.
- [x] App-level UI Tests.
- [x] Test Helpers + Mocktail.

**التغطية الحالية:** 18 ملف اختبار تقريبًا و87 حالة اختبار وفق الفحص السابق.

### A. Offline & Sync Testing

- [ ] 🆕 Local Database Tests.
- [ ] 🆕 Database Migration Tests.
- [ ] 🆕 Offline Read Tests.
- [ ] 🆕 Offline Write Tests.
- [ ] 🆕 Sync Engine Tests.
- [ ] 🆕 Pending Operations Queue Tests.
- [ ] 🆕 Retry Mechanism Tests.
- [ ] 🆕 Exponential Backoff Tests.
- [ ] 🆕 Idempotency Tests.
- [ ] 🆕 Conflict Resolution Tests.
- [ ] 🆕 Multi-Device Synchronization Tests.
- [ ] 🆕 Soft Delete & Restore Tests.
- [ ] 🆕 Tombstone Synchronization Tests.

### B. Search & Recycle Bin Testing

- [ ] 🆕 Advanced Search Tests.
- [ ] 🆕 Combined Search Criteria Tests.
- [ ] 🆕 AND / OR Logic Tests.
- [ ] 🆕 Search History Tests.
- [ ] 🆕 Recently Added / Modified Tests.
- [ ] 🆕 Recycle Bin Tests.
- [ ] 🆕 Restore Deleted Records Tests.
- [ ] 🆕 Permanent Delete Tests.

### C. Security Testing

- [ ] 🆕 Rate Limiting Tests.
- [ ] 🆕 Temporary Lockout Tests.
- [ ] 🆕 Access Code Expiration Tests.
- [ ] 🆕 Device Registration Tests.
- [ ] 🆕 Device Revocation Tests.
- [ ] 🆕 Unauthorized Device Access Tests.
- [ ] 🆕 Access Audit Log Tests.
- [ ] 🆕 Firestore Security Rules Tests.
- [ ] 🆕 Sensitive Screen Protection Tests.
- [ ] 🆕 Screenshot Protection Tests.

### D. Integration & End-to-End Testing

- [ ] 🆕 Integration Testing لتدفقات العمليات بين الطبقات.
- [ ] 🆕 Firebase Emulator Suite.
- [ ] 🆕 اختبار Firestore Security Rules باستخدام Emulator.
- [ ] 🆕 End-to-End Tests للسيناريوهات الأساسية.
- [ ] 🆕 اختبار فقدان الإنترنت أثناء عملية كتابة.
- [ ] 🆕 اختبار عودة الإنترنت وتنفيذ العمليات المعلقة.
- [ ] 🆕 اختبار تعارض التعديلات بين جهازين.
- [ ] 🆕 اختبار Recycle Bin مع المزامنة.

## ❌ المرحلة 11 — التسليم المباشر (Google Drive → APK)

### المهام الأصلية

- [ ] إعداد Release Signing: Keystore + `key.properties` خارج Git.
- [ ] إعداد `signingConfig` في `android/app/build.gradle.kts`.
- [ ] نجاح `flutter build apk --release`.
- [ ] التأكد من تثبيت وتشغيل APK على أجهزة العميل.
- [ ] التحقق من SHA-256 وVersion Code.
- [ ] رفع APK على Google Drive.
- [ ] مشاركة رابط View-only.
- [ ] مراجعة App Icon وNative Splash في Release Build.
- [ ] توثيق Keystore ومكان حفظه وأوامر البناء والبصمة وطريقة التسليم.
- [ ] إزالة الكود التجريبي `KORYA` قبل التسليم.

### شروط التسليم

- [ ] التأكد من عدم وجود إعدادات أو بيانات تجريبية.
- [ ] التأكد من أن النسخة النهائية متصلة بمشروع Firebase الصحيح.
- [ ] التأكد من صلاحية Firestore Rules.
- [ ] اختبار التطبيق بعد تثبيته من APK وليس من بيئة التطوير فقط.
- [ ] التأكد من حفظ Keystore بطريقة آمنة.

**ملاحظة:** لا GitHub Actions ولا CI/CD ضمن نطاق هذه المرحلة؛ التسليم يظل يدويًا عبر Google Drive كما في الخطة الأصلية.

---

## 📊 ملخص التطويرات الجديدة

### الميزات والتحديات المضافة

1. Advanced Search.
2. Search History.
3. Recently Added / Modified.
4. Recycle Bin.
5. Local Database باستخدام Drift.
6. Offline-First Architecture.
7. Synchronization Engine.
8. Pending Operations Queue.
9. Retry + Exponential Backoff.
10. Idempotent Operations.
11. Conflict Resolution.
12. Soft Delete + Tombstones.
13. Device Registration.
14. Device Revocation.
15. Rate Limiting.
16. Temporary Lockout.
17. Access Code Expiration.
18. Access Audit Log.
19. Server-Side Validation.
20. Secure Sensitive Screens.
21. Screenshot Protection.
22. Integration Testing.
23. Firebase Emulator Testing.
24. Multi-Device Synchronization Testing.
25. Security Rules Testing.

### أهم الفجوات التي سنعمل على حلها

- لا توجد قاعدة بيانات محلية أو Offline Support.
- لا يوجد Synchronization Engine.
- لا توجد سياسة Conflict Resolution.
- لا يوجد Recycle Bin أو Soft Delete.
- لا توجد إدارة للأجهزة المرتبطة.
- لا توجد حماية من تخمين Access Code.
- لا يوجد Access Audit Log.
- لا توجد حماية للشاشات الحساسة من Recent Apps وScreenshots.
- لا توجد اختبارات تكاملية كافية للسيناريوهات الجديدة.
- لا يزال Release Signing والتسليم النهائي غير مكتملين.

## 📌 قرارات معمارية ثابتة

- Riverpod يظل State Management المستخدم في المشروع.
- الحفاظ على Feature-First Clean Architecture.
- الحفاظ على Domain / Data / Presentation Separation.
- عدم وضع Business Logic داخل UI.
- عدم تغيير التقنيات الحالية دون سبب معماري واضح.
- كل Feature جديدة يجب أن تكون لها اختبارات مناسبة.
- كل عملية Offline يجب أن يكون لها سلوك واضح عند المزامنة.
- الأمان الحقيقي للعمليات الحساسة يجب ألا يعتمد على Flutter Client وحده.
- لا تتم إضافة أي تعقيدات لا تحقق قيمة فعلية للمشروع.

---

## 🎯 الهدف النهائي

تحويل Car Register من تطبيق بسيط لإدارة أرقام البروشورات ومشاركتها إلى تطبيق يدعم:

- Offline-First Data Management.
- Reliable Multi-Device Synchronization.
- Secure Shared Access.
- Device Management.
- Advanced Data Search.
- Data Recovery.
- Local & Remote Data Consistency.
- Automated Testing للسيناريوهات المعقدة.

مع الحفاظ على البنية الحالية والتقنيات المختارة، وتطبيق كل تطوير كحل لمشكلة حقيقية يمكن شرحه ومناقشته في Technical Interview.