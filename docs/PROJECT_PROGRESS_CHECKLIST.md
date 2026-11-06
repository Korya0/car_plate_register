# Car Register — مراحل التنفيذ والتشيك ليست (Progress Checklist)

**المرجع:** `docs/PROJECT_SPECIFICATION.md` (v1.3)
**تاريخ الفحص:** 2026-11-06
**نطاق الفحص:** كل ملفات `lib/` (core + 3 features) و`test/` (18 ملف ≈ 87 حالة test) و`android/` و`firestore.rules` و`pubspec.yaml` و`README.md` و`docs/`

| الرمز | المعنى |
|---|---|
| ✅ مكتمل | مطبّق فعليًا في الكود (كود + غالبًا اختبار) |
| 🟡 جزئي | مطبّق جزئيًا أو فيه فجوة/تناقض ملحوظ |
| ❌ غير منفّذ | ينعدم من الكود والمواصفة تطلبه |

---

## ✅ المرحلة 1 — الإعداد والتأسيس

- [x] إعداد `pubspec.yaml` كامل: Riverpod, go_router, Firebase (core + Firestore), flutter_secure_storage, local_auth, mocktail/flutter_lints — ونطاق SDK صحيح (`sdk: ^3.13.3`)
- [x] package name مضبوط: `com.korya0.car_register` + versioning صحيح (1.0.0+1)
- [x] Theme واحد (Light Material3) + خط Cairo في `lib/core/theme/` (`app_theme.dart`, `app_colors.dart`, `app_text_styles.dart`, `app_font.dart`)
- [x] Assets + fonts + native splash منظّمة في pubspec (`assets/images`, `assets/native`, `assets/fonts/cairo`)
- [x] قواعد lint مفعّلة: `analysis_options.yaml` + `flutter_lints ^6.0.0`
- [x] Firebase Android config: `android/app/google-services.json` + `lib/core/services/firebase/firebase_options.dart` (generated)
- [x] `.firebaserc` موجودة في الجذر
- [x] ✅ تم حل توحيد هوية مشروع Firebase: `.firebaserc` → `car-register-7e6e6` بينما `google-services.json` → `car-registration-30663` — **mismatch** الملفّين مش شغّالين على مشروع واحد
- [x] ✅ No CLI scaffolding الملفّين `firebase.json` و`firestore.indexes.json` اتحذفوا — ما فيش deploy عن طريق CLI، القواعد موجودة فعليًا في الـ Firebase Console (المشروع `car-registration-30663`)؛ الريبو محتفظ بـ `.firebaserc` و`firestore.rules` بس

## ✅ المرحلة 2 — البنية الأساسية (Core)

- [x] Feature-First Clean Architecture فعلية: `domain/` + `data/` + `presentation/` لكل feature (`home`, `access_control`, `local_auth`)
- [x] نظام أخطاء ونتائج واضح: `lib/core/error/result.dart` + `failure.dart` (مغطى باختبار `test/core/error/result_test.dart`)
- [x] حقن التوابع عبر Riverpod providers: `lib/core/di/app_providers.dart` + `app_initializer.dart`
- [x] Router موحّد بـ go_router: `/access-code` (initial) → `/home` → `/search` في `lib/core/router/`
- [x] مكتبة widgets مشتركة flat في `lib/core/widgets/` (17 widget: `app_text_field.dart`, `custom_confirmation_dialog.dart`, `app_error_view.dart`, ...) — مطابقة لقواعد `docs/architecture/03_code_conventions.md`
- [x] `AppLogger` + `AppProviderObserver` في `lib/core/utils/`
- [x] Validators مركزية لرقم البروشور + كود الوصول (`lib/core/utils/app_validators.dart`)
- [x] وثائق دليلية محفوظة: `docs/architecture/`, `docs/design_system/`, `docs/ui/`

## ✅ المرحلة 3 — أرقام البروشورات (Brochure Numbers)

- [x] إضافة رقم وحفظه في Firestore تحت `access_codes/{code}/plates` (`brochure_remote_data_source.dart`)
- [x] تحقق 1–4 أرقام فقط (`brochure_number_validator.dart` + `app_validators.dart`)
- [x] الاحتفاظ بصفر البداية مثل `007` — تخزين `String` + تسوية إلى 4 أرقام في `brochure_repository_impl.dart` (الحفظ في Firestore بنوع string ليس int)
- [x] عرض الأرقام في قائمة مع وقت الإضافة (`brochure_entity.dart` {id, number, createdAt} + `home_brochure_entry_row.dart`)
- [x] البحث عن الأرقام — شاشة كاملة `search_view.dart` + `search_brochure_use_case.dart`
- [x] حذف رقم مع تأكيد الحذف (`custom_confirmation_dialog.dart` قبل التنفيذ)
- [x] حذف متعدد عبر selection bar (long-press → تحديد الكل → حذف المحدد) في `brochure_list_body.dart`
- [x] عرض عدد الأرقام المسجّلة كعداد ديناميكي في هيدر Home (سطر `عدد الأرقام المسجلة: N` تحت اسم التطبيق — `HomeHeaderContent` بـ `registeredCount`)

## 🟡 المرحلة 4 — مشاركة البيانات (Shared Access PIN)

- [x] شاشة إدخال الكود `access_code_view.dart` + `access_code_form.dart`: validation (حد أقصى 10 أحرف لاتينية/أرقام فقط عبر `app_validators.accessCode`) + التحويل إلى `/home` عند النجاح
- [x] التحقق من الكود مقابل وثيقة Firestore `access_codes/{code}` + علم `isActive` (`access_control_remote_data_source.dart`) — "التحقق على الخادم" معتمد على Firestore rules وقراءة الـ doc
- [x] الكود يُدخل مرة واحدة عند ربط الجهاز ولا يُطلب مجددًا في الإضافة/الحذف/العمليات العادية — يعيش أثناء الجلسة في `accessCodeProvider`
- [x] لا يوجد تسجيل دخول إيميل/باسورد ولا شاشة لإنشاء/عرض Share Code داخل التطبيق (متوافق مع §2.2)
- [x] انتهاء/إبطال الكود: `accessCodeInvalid` في `home_view_model.dart` يفرَغ الـ provider ويعيد التوجيه تلقائيًا إلى `/access-code`
- [ ] ❌ منع محاولات التخمين المتكررة للكود (throttling/lockout) — غير موجود نهائيًا (§5)

## ❌ المرحلة 5 — العمل أوفلاين والمزامنة (Offline & Sync) — غير منفّذة

- [x] إقرار معلَن: `README.md` §Cloud Data يقول صراحة "Session Cache Only — there is no local database or offline sync yet"
- [ ] ❌ قاعدة بيانات محلية (SQLite / Drift) — **لا يوجد أي dependency لقاعدة محلية في pubspec** (لا drift ولا sqflite ولا shared_preferences)
- [ ] ❌ العمل دون إنترنت وعرض البيانات المخزّنة محليًا
- [ ] ❌ حفظ التغييرات محليًا ومزامنتها عند عودة الإنترنت (لا sync service ولا outbox/queue)
- [ ] ❌ منع تكرار السجلات بسبب إعادة المحاولة — الاستثناء الوحيد (de-facto) أن doc ID يساوي الرقم المعدّل (padded) بـ `_platesRef.doc(number).set(...)`، وهذه ليست ميكانيزم retry مضمونًا
- [ ] ❌ منع ظهور السجلات المحذوفة مجددًا بعد المزامنة — لا يوجد soft-delete / `isDeleted` في الكود إطلاقًا
- [ ] ❌ التعامل مع تعارضات عدة أجهزة — لا سياسة محسومة ولا كود، وهي أيضًا ضمن §8 Pending Decisions

## 🟡 المرحلة 6 — قفل التطبيق (App Lock)

- [x] بنية local_auth صحيحة: `local_auth_service.dart` + ربط exception codes بـ `LocalAuthResult` (success / cancelled / unavailable / notEnrolled / lockedOut / busy / error) مغطية بـ 12 حالة اختبار
- [x] Guard اختياري `runWithLocalAuth` في `local_auth_guard.dart` + فحص `isDeviceSupported()` قبل الطلب
- [x] fallback لاعتمادات الجهاز (PIN/pattern/biometric) بمعايير `authenticate(biometricOnly: false)`

## ✅ المرحلة 8 — واجهة الاستخدام (UI/UX)

- [x] واجهة عربية بالكامل: strings عربية ثابتة في `app_strings.dart` + `locale: 'ar'` + supportedLocales `['ar']` + global delegates في `app.dart`
- [x] RTL محكم: `EdgeInsetsDirectional` + اختبار متعمد أن الأرقام تتوزع LTR داخل RTL (`test/core/widgets/app_text_field_test.dart`)
- [x] Theme واحد فقط في الإصدار الأول (Light Material3، لا dark mode) — متوافق مع §3
- [x] شاشة إضافة وعرض الأرقام: `HomeView` (input + list + delete)
- [x] شاشة بحث مفصولة: `SearchView` (رجوع + filter + delete + refresh)
- [x] تأكيد واضح قبل الحذف (فردي / متعدد) + "كل الأرقام" عبر تحديد الكل (اقترح زرًا واضحاً)
- [x] حالة skeleton loading (`skeletonizer` + `HomeBrochureEntryRow.loading`)
- [x] حالة القائمة الفارغة + حالة لا نتائج (`home_brochure_empty_state.dart`)
- [x] شاشات خطأ: `app_error_view.dart` + error dialog + strings خطأ (404 في router كذلك)
- [x] منع تغيّر خط النظام (`preventTextScaling`) + edge-to-edge + keyboard dismiss عند اللمس/السحب (`test/widget_test.dart`)

## 🟡 المرحلة 9 — قاعدة البيانات والأمان (DB & Security)

- [x] نموذج السجل بالحقول المطلوبة: id / brochureNumber (String) / createdAt (`brochure_entity.dart` + `brochure_model.dart` with fromFirestore/toMap)
- [x] التجميع تحت `access_codes/{code}/plates` (subcollection لكل عميل) — يعكس ربط الجهاز المصرّح بمجموعة بيانات العميل (§5)
- [x] `firestore.rules`: قراءة `access_codes/{code}` متاحة (للتحقق من الكود) و`list` و`write` على access codes مرفوضة (إدارة الكود من الخارج/الوضع الإداري)
- [x] كتابة plates مقيدة بوجود الـ parent وأنّه `isActive == true` (helper `isCodeActive()`)
- [x] الرجوع للشاشة عند access code غير صالح أثناء الأوامر (permission-denied / not-found → redirect)
- [x] لا توجد مفاتيح إدارة سرية داخل التطبيق (لا admin SDK ولا service account في `lib/`)
- [ ] ❌ حماية من تخمين الكود: الـ rules تسمح بـ `get: if true` **بدون throttle ولا عدّادات محاولات** (§5 بند "منع محاولات التخمين المتكررة")

## 🟡 المرحلة 10 — الاختبارات (Testing)

**المغطّى (18 ملف ≈ 87 حالة):**
- [x] validators الأرقام — الأصفار البادئة + رفض >4 أرقام / فارغ / غير رقمي / `0000` (`brochure_number_validator_test.dart`)
- [x] repository: padded ops + duplicate rejection بدون backend + delete purge + بحث داخلي + ربط الـ use cases بـ mocks (`brochure_repository_impl_test.dart`)
- [x] شاشة Home كاملة: add/delete + empty + keyboard dismiss + selection mode (long-press/select-all/multi-delete/clear) + عدم وجود أيقونة حذف per-card + لوحة أرقام رقمية (`home_view_test.dart` — 12 حالة)
- [x] شاشة البحث: navigation + filtering + حذف وrefresh بعد الحذف + حالة نتائج فارغة (`search_view_test.dart` — 8 حالات)
- [x] شاشة كود الوصول: animations + validation + رسالة الكود غير الصحيح + افتتاح الكود التجريبي `KORYA` (`access_code_view_test.dart` — 8 حالات)
- [x] `ValidateAccessCodeUseCase` (`validate_access_code_use_case_test.dart`)
- [x] local_auth: الخدمة (12 حالة) + الـ Guard (skip عند disabled، تشغيل بعد success، block عند cancel/unavailable)
- [x] widgets أساسية: `app_text_field_test.dart` (LTR digits داخل RTL + backspace من النهاية) + `app_theme_test.dart` (Cairo هو الخط الوحيد)
- [x] `Result` semantics (`test/core/error/result_test.dart`)
- [x] مستويات app-level: focus borders، keyboard dismiss بالسحب، edge-to-edge/transparent bars (`test/widget_test.dart`)
- [x] اختبار helpers: `fake_local_auth_service.dart`, `home_test_helpers.dart` + use of `mocktail`

## ❌ المرحلة 11 — التسليم المباشر (Google Drive → APK)

**الهدف:** بناء APK موقّع وإرساله للعميل عبر Google Drive — بدون متجر وبدون pipeline.

- [ ] ❌ إعداد توقيع الـ release: إنشاء/استخدام keystore + `key.properties` خارج git + `signingConfig` release في `android/app/build.gradle.kts`
- [ ] ❌ `flutter build apk --release` ينجح و الـ APK بيثبت ويفتح على أجهزة العميل (SHA-256 + versionCode محدّث)
- [ ] ❌ رفع الـ APK على Google Drive ومشاركة اللينك (view-only) مع العميل
- [ ] 🟡 app icon + native splash assets جاهزة (`flutter_launcher_icons`, `flutter_native_splash`) — مطلوب التأكد من سلامتها في بناء release
- [ ] 🟡 توثيق تسليم قصير: مكان حفظ الـ keystore + الأوامر + البصمة + طريقة استلام الـ APK من الـ Drive

ملاحظة: عناصر GitHub Actions والـ CI أُسقطت من الخطة — التسليم يدوي عبر Drive فقط، ولا pipeline مطلوب هنا. ولو اتقرر إضافة CI مستقبلًا يترجع كمرحلة جديدة بإرادتك.

---

## 📊 الخلاصة — الفجوات الحرجة (مرتبة حسب الأهمية)

1. **لا قاعدة بيانات محلية ولا أوفلاين ولا مزامنة** — المرحلة 5 كاملة غير منفّذة (§2.3)، وهي جوهر "مشاركة البيانات بين أجهزة" في نظرة عامة للمشروع §1
2. **لا توقيع release ولا APK موقّع ولا تسليم على Drive** — المرحلة 11
3. **حماية من تخمين الكود** — rules تسمح بـ `get: if true` بدون throttling (§5)
4. **Firebase project mismatch**: ✅ تم حلها — `.firebaserc` يعمل الآن على `car-registration-30663` مثل `google-services.json` ✔
5. **كود تجريبي `KORYA` في `app_constants.dart`** مع تعليق "Temporary until the access API is wired" — لازم يُرفع قبل التسليم

## ⚡ مكاسب سريعة مقترحة

- إعداد توقيع الـ release + رفع الـ APK على Google Drive — أقرب طريق لتسليم العميل
- إزالة `KORYA` demo قبل التسليم