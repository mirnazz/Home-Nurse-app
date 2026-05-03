// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcomeBackTitle => 'مرحباً بعودتك!';

  @override
  String get signInToContinue => 'سجّل الدخول للمتابعة';

  @override
  String get emailAddressLabel => 'البريد الإلكتروني';

  @override
  String get emailFieldHint => 'بريدك@example.com';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordFieldHint => 'أدخل كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get createNewAccount => 'إنشاء حساب جديد';

  @override
  String get errorValidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get errorEnterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String errorUnknownNurseStatus(String status) {
    return 'حالة التحقق للممرض غير معروفة: $status';
  }

  @override
  String errorUnknownRole(String role) {
    return 'دور غير معروف: $role';
  }

  @override
  String errorLoginFailed(String message) {
    return 'فشل تسجيل الدخول: $message';
  }

  @override
  String get signupCreateNurseAccount => 'إنشاء حساب ممرض';

  @override
  String get signupCreateAccount => 'إنشاء حساب';

  @override
  String get signupNurseSubtitle => 'أكمل تسجيلك كممرض في خطوتين';

  @override
  String get signupPatientSubtitle => 'سجّل للبدء';

  @override
  String get signupStep1Of4 => 'الخطوة 1 من 4';

  @override
  String get signupIAmA => 'أنا:';

  @override
  String get rolePatient => 'مريض';

  @override
  String get roleNurse => 'ممرض';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get fullNameHint => 'أدخل اسمك الكامل';

  @override
  String get validationFullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get signupEmailLabel => 'البريد الإلكتروني';

  @override
  String get signupEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get validationEmailInvalid => 'أدخل بريداً إلكترونياً صالحاً';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get phoneNumberHint => 'مثال: 0790000000';

  @override
  String get validationPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get validationPhoneInvalid => 'أدخل رقم هاتف صالحاً';

  @override
  String get signupPasswordLabel => 'كلمة المرور';

  @override
  String get signupPasswordHint => 'أنشئ كلمة مرور';

  @override
  String get validationPasswordMin => '6 أحرف على الأقل';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أكد كلمة المرور';

  @override
  String get validationPasswordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get continueButton => 'متابعة';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signupFooterNurse => 'ستكمل التحقق في الخطوة التالية.';

  @override
  String get signupFooterPatient => 'أنشئ حسابك للمتابعة.';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String signUpErrorFailed(String message) {
    return 'فشل إنشاء الحساب: $message';
  }

  @override
  String get patientNavHome => 'الرئيسية';

  @override
  String get patientNavNurses => 'الممرضين';

  @override
  String get patientNavAppointments => 'المواعيد';

  @override
  String get patientNavPayments => 'المدفوعات';

  @override
  String get patientNavMore => 'المزيد';

  @override
  String get patientWelcomeBackLine => 'مرحبًا بعودتك،';

  @override
  String get patientSearchNursesHint =>
      'ابحث عن ممرض حسب الاسم أو نوع الخدمة...';

  @override
  String get patientQuickServices => 'خدمات التمريض السريعة';

  @override
  String get patientUpcomingAppointments => 'المواعيد القادمة';

  @override
  String get patientViewAll => 'عرض الكل';

  @override
  String get patientTotalBookings => 'عدد الحجوزات';

  @override
  String get patientActiveRequests => 'الطلبات الحالية';

  @override
  String get patientAppointmentsPlaceholder => 'لا توجد مواعيد حاليا';

  @override
  String get patientLogout => 'تسجيل الخروج';

  @override
  String get patientServiceIvTherapy => 'العلاج\nالوريدي';

  @override
  String get patientServiceWoundCare => 'العناية\nبالجروح';

  @override
  String get patientServicePostSurgery => 'رعاية ما بعد\nالجراحة';

  @override
  String get patientServiceMedication => 'إدارة\nالأدوية';

  @override
  String get patientRateExperienceTitle => 'قيّم تجربتك';

  @override
  String patientRateExperienceSubtitle(String nurseName) {
    return 'ساعد الآخرين بمشاركة ملاحظاتك\nحول $nurseName';
  }

  @override
  String get patientWriteReview => 'اكتب تقييماً';

  @override
  String get patientReviewSubmittedThanks => 'شكراً! تم إرسال تقييمك.';

  @override
  String patientLogoutFailed(String message) {
    return 'فشل تسجيل الخروج: $message';
  }

  @override
  String get user => 'مستخدم';

  @override
  String get patientRetry => 'إعادة المحاولة';

  @override
  String get patientBrowseTitle => 'تصفح الممرضين';

  @override
  String get patientBrowseSearchHint =>
      'ابحث عن ممرض حسب الاسم أو نوع الخدمة...';

  @override
  String get patientBrowseFilters => 'عوامل التصفية';

  @override
  String get patientBrowseFilterSheetTitle => 'تصفية الممرضين';

  @override
  String get patientBrowseReset => 'إعادة تعيين';

  @override
  String get patientBrowseServiceType => 'نوع الخدمة';

  @override
  String get patientBrowseChooseService => 'اختر خدمة';

  @override
  String get patientBrowseAllServices => 'كل الخدمات';

  @override
  String get patientBrowseGovernorate => 'المحافظة';

  @override
  String get patientBrowseAllLocations => 'كل المواقع';

  @override
  String get patientGovZarqa => 'الزرقاء';

  @override
  String get patientGovIrbid => 'إربد';

  @override
  String get patientGovAmman => 'عمّان';

  @override
  String get patientGovTafilah => 'الطفيلة';

  @override
  String get patientGovKarak => 'الكرك';

  @override
  String get patientGovMadaba => 'مادبا';

  @override
  String get patientGovBalqa => 'البلقاء';

  @override
  String get patientGovAjloun => 'عجلون';

  @override
  String get patientGovJerash => 'جرش';

  @override
  String get patientGovAqaba => 'العقبة';

  @override
  String get patientGovMaan => 'معان';

  @override
  String get patientGovMafraq => 'المفرق';

  @override
  String get patientBrowseApplyFilters => 'عرض النتائج';

  @override
  String get patientBrowseClearAll => 'مسح الكل';

  @override
  String patientBrowseFoundNurses(int count) {
    return 'تم العثور على $count ممرضاً';
  }

  @override
  String patientBrowsePageIndicator(int current, int total) {
    return 'صفحة $current/$total';
  }

  @override
  String get patientBrowseNoResults => 'لا يوجد ممرضون مطابقون لعوامل التصفية.';

  @override
  String get patientBrowseViewProfile => 'عرض الملف';

  @override
  String patientBrowseExperienceYears(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years سنة خبرة',
      many: '$years سنة خبرة',
      few: '$years سنوات خبرة',
      two: 'سنتين خبرة',
      one: 'سنة خبرة',
    );
    return '$_temp0';
  }

  @override
  String get patientBrowseCatalog1 => 'العلاج الوريدي';

  @override
  String get patientBrowseCatalog2 => 'عناية الجروح والتضميد';

  @override
  String get patientBrowseCatalog3 => 'إعطاء الأدوية';

  @override
  String get patientBrowseCatalog4 => 'رعاية ما بعد الجراحة';

  @override
  String get patientBrowseCatalog5 => 'إدارة الأدوية';

  @override
  String get patientBrowseCatalog6 => 'مراقبة العلامات الحيوية';

  @override
  String get patientBrowseCatalog7 => 'سحب دم أو عينة مخبرية';

  @override
  String get patientBrowseCatalog8 => 'عناية القسطرة';

  @override
  String get patientBrowseCatalog9 => 'متابعة السكري وحقن الأنسولين';

  @override
  String get patientBrowseCatalog10 => 'زيارة رعاية منزلية لكبار السن';

  @override
  String get patientBrowseCatalog11 => 'تركيب أكسجين منزلي';

  @override
  String get patientBrowseCatalog12 => 'جلسة بخار';

  @override
  String get patientBrowseCatalog13 => 'إزالة الغرز';

  @override
  String get patientBrowseCatalog14 => 'عناية قرح الفراش';

  @override
  String get patientBrowseCatalog15 => 'زيارة تمريض منزلية';

  @override
  String get patientBrowseCatalog16 => 'فحص ضغط الدم';

  @override
  String get patientBrowseCatalog17 => 'رعاية قصيرة (4 ساعات)';

  @override
  String get patientBrowseCatalog18 => 'رعاية نصف يوم (6 ساعات)';

  @override
  String get patientBrowseCatalog19 => 'رعاية يوم كامل (12 ساعة)';

  @override
  String get patientAppointmentsTitle => 'مواعيدي';

  @override
  String patientAppointmentsUpcomingCount(int count) {
    return 'القادمة ($count)';
  }

  @override
  String patientAppointmentsPastCount(int count) {
    return 'السابقة ($count)';
  }

  @override
  String get patientAppointmentsNoUpcoming => 'لا توجد مواعيد قادمة.';

  @override
  String get patientAppointmentsNoPast => 'لا توجد مواعيد سابقة.';

  @override
  String get patientAppointmentsLoadFailed => 'تعذّر تحميل المواعيد';

  @override
  String get patientAppointmentTotal => 'الإجمالي';

  @override
  String get patientAppointmentStatusPending => 'قيد الانتظار';

  @override
  String get patientAppointmentStatusConfirmed => 'مؤكد';

  @override
  String get patientAppointmentStatusActivePaid => 'نشط/مدفوع';

  @override
  String get patientAppointmentStatusCompleted => 'مكتمل';

  @override
  String get patientAppointmentStatusCancelled => 'ملغى';

  @override
  String get patientAppointmentStatusRejected => 'مرفوض';

  @override
  String get patientPayBannerTitlePayContinue => 'ادفع للمتابعة';

  @override
  String get patientPayBannerTitlePaymentRequired => 'الدفع مطلوب';

  @override
  String get patientPayBannerBodyPayContinue =>
      'أكد الممرض موعدك. أكمل الدفع لتفعيل الحجز والاحتفاظ به.';

  @override
  String get patientPayBannerBodyPaymentRequired => 'أكمل الدفع لتأكيد موعدك.';

  @override
  String get patientPaymentTitle => 'الدفع';

  @override
  String get patientPaymentBookingSummary => 'ملخص الحجز';

  @override
  String get patientPaymentLabelNurse => 'الممرض';

  @override
  String get patientPaymentLabelService => 'الخدمة';

  @override
  String get patientPaymentLabelDate => 'التاريخ';

  @override
  String get patientPaymentLabelTime => 'الوقت';

  @override
  String get patientPaymentLabelAmount => 'المبلغ';

  @override
  String get patientPaymentMethod => 'طريقة الدفع';

  @override
  String get patientPaymentStripeDisabled =>
      'دفع البطاقة (Stripe) معطّل في هذا الإصدار للتطوير المحلي.';

  @override
  String get patientPaymentConfirm => 'تأكيد الدفع';

  @override
  String get patientPaymentStripeDisabledSnack =>
      'Stripe معطّل في هذا الإصدار. أعد تفعيل flutter_stripe في pubspec واستعد دالة الدفع.';

  @override
  String patientPaymentError(String message) {
    return 'خطأ في الدفع: $message';
  }

  @override
  String get patientMoreProfileTitle => 'الملف الشخصي';

  @override
  String get patientMoreProfileSubtitle => 'عرض وتعديل معلوماتك';

  @override
  String get patientPaymentsTabEmpty =>
      'ستظهر هنا سجل المدفوعات والإيصالات عند توفرها.';

  @override
  String get patientReviewSetRatingFirstSnack =>
      'يرجى تحديد التقييم العام أولاً.';

  @override
  String get patientReviewOverallRating => 'التقييم العام';

  @override
  String get patientReviewTapToRate => 'اضغط للتقييم';

  @override
  String get patientReviewRateSpecificAreas => 'قيّم الجوانب التفصيلية';

  @override
  String get patientReviewProfessionalism => 'الاحترافية';

  @override
  String get patientReviewPunctuality => 'الالتزام بالموعد';

  @override
  String get patientReviewCommunication => 'التواصل';

  @override
  String get patientReviewServiceQuality => 'جودة الخدمة';

  @override
  String get patientReviewTextOptional => 'نص التقييم (اختياري)';

  @override
  String get patientReviewTextHint => 'شارك تفاصيل عن تجربتك...';

  @override
  String get patientReviewLater => 'لاحقاً';

  @override
  String get patientReviewSubmit => 'إرسال التقييم';

  @override
  String get patientReviewServiceShort => 'الخدمة';

  @override
  String patientReviewServiceLine(String name) {
    return 'الخدمة: $name';
  }

  @override
  String get patientReviewNurseShort => 'الممرض';

  @override
  String patientReviewNurseLine(String name) {
    return 'الممرض: $name';
  }

  @override
  String get patientReviewCloseTooltip => 'إغلاق';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get personalInfo => 'المعلومات الشخصية';

  @override
  String get profileAddressSection => 'العنوان';

  @override
  String get profileMedicalSection => 'المعلومات الطبية';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get gender => 'الجنس';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get bloodType => 'فصيلة الدم';

  @override
  String get address => 'العنوان';

  @override
  String get governorate => 'المحافظة';

  @override
  String get area => 'المنطقة';

  @override
  String get profileEditProfile => 'تعديل الملف';

  @override
  String get profileCancel => 'إلغاء';

  @override
  String get profileSave => 'حفظ';

  @override
  String get profileSelectGender => 'اختر الجنس';

  @override
  String get profileSelectBloodType => 'اختر فصيلة الدم';

  @override
  String get profileSelectGovernorate => 'اختر المحافظة';

  @override
  String get profileSelectDate => 'اختر التاريخ';

  @override
  String get profileUpdatedSuccess => 'تم تحديث الملف بنجاح.';

  @override
  String get profileConditions => 'الحالات الصحية';

  @override
  String get profileAllergies => 'الحساسية';

  @override
  String get profileNotes => 'ملاحظات';

  @override
  String get profileNoneCombinationWarning =>
      'لا يمكن الجمع بين «لا يوجد» وحالات أخرى.';

  @override
  String get profileOtherConditionOptional => 'حالة أخرى (اختياري)';

  @override
  String get profileConditionHint => 'مثال: سرطان، أمراض الكلى';

  @override
  String get profileOtherAllergiesOptional => 'حساسيات أخرى (اختياري)';

  @override
  String get profileAllergiesHint => 'مثال: مأكولات بحرية، أسبرين';

  @override
  String get profileConditionDiabetes => 'السكري';

  @override
  String get profileConditionHypertension => 'ضغط الدم';

  @override
  String get profileConditionAsthma => 'الربو';

  @override
  String get profileConditionHeartDisease => 'أمراض القلب';

  @override
  String get profileConditionArthritis => 'التهاب المفاصل';

  @override
  String get profileConditionNone => 'لا يوجد';

  @override
  String get profileGenderMale => 'ذكر';

  @override
  String get profileGenderFemale => 'أنثى';

  @override
  String get profileAllergyPenicillin => 'البنسلين';

  @override
  String get profileAllergyDust => 'الغبار';

  @override
  String get profileAllergyFood => 'الطعام';

  @override
  String get profileAllergyLatex => 'اللاتكس';

  @override
  String get profileAllergyPollen => 'حبوب اللقاح';

  @override
  String get notLoggedIn => 'يرجى تسجيل الدخول أولاً';

  @override
  String get patientMoreLanguage => 'اللغة';

  @override
  String get patientMoreLanguageEnglish => 'English';

  @override
  String get patientMoreLanguageArabic => 'العربية';

  @override
  String get patientMoreLanguageSubtitle => 'تغيير لغة التطبيق';

  @override
  String get patientMoreSignOutSubtitle => 'تسجيل الخروج من حسابك';

  @override
  String get languageSelectorTitle => 'اختر اللغة';

  @override
  String get languageSelectorSubtitle => 'تغيير لغة التطبيق';

  @override
  String get nurseHomeWelcomeBack => 'مرحبًا بعودتك،';

  @override
  String get nurseHomeDefaultName => 'ممرض/ة';

  @override
  String get nurseHomeSummaryTodayAppointments => 'مواعيد اليوم';

  @override
  String get nurseHomeSummaryPendingRequests => 'طلبات بانتظار الموافقة';

  @override
  String get nurseHomeSummaryJodToday => 'أرباح اليوم';

  @override
  String get nurseHomeWeekSummaryTitle => 'ملخص هذا الأسبوع';

  @override
  String get nurseHomeWeekCompleted => 'مكتملة';

  @override
  String get nurseHomeWeekCancelled => 'ملغاة';

  @override
  String get nurseHomeWeekJodEarned => 'إجمالي الأرباح';

  @override
  String get nurseHomeQuickActionsTitle => 'إجراءات سريعة';

  @override
  String get nurseHomeActionManageAvailabilityTitle => 'إدارة أوقات العمل';

  @override
  String get nurseHomeActionManageAvailabilitySubtitle => 'حدد أوقات عملك';

  @override
  String get nurseHomeActionViewRequestsTitle => 'طلبات المرضى';

  @override
  String get nurseHomeActionViewRequestsSubtitle =>
      'عرض الطلبات المعلقة والمرفوضة';

  @override
  String get nurseHomeActionAppointmentsTitle => 'مواعيدي';

  @override
  String get nurseHomeActionAppointmentsSubtitle => 'عرض مواعيدك';

  @override
  String get nurseHomeTodayScheduleTitle => 'جدول اليوم';

  @override
  String get nurseHomeViewAll => 'عرض الكل';

  @override
  String get nurseStatusAccepted => 'مقبول';

  @override
  String get nurseStatusActive => 'نشط';

  @override
  String get nurseStatusCompleted => 'مكتمل';

  @override
  String get nurseStatusCancelled => 'ملغى';

  @override
  String get nurseStatusRejected => 'مرفوض';

  @override
  String get nurseStatusPending => 'قيد الانتظار';

  @override
  String get nurseHomePatientFallback => 'مريض';

  @override
  String nurseHomeEarningsJod(String amount) {
    return '$amount د.أ';
  }

  @override
  String get nurseHomeNoAppointmentsToday => 'لا توجد مواعيد اليوم';

  @override
  String get nurseHomeNoAppointmentsTodayHint => 'ستظهر مواعيد اليوم هنا.';

  @override
  String get nurseHomeAvailableTitle => 'أنت متاح';

  @override
  String get nurseHomeAvailableSubtitle => 'يمكنك استقبال طلبات خدمة جديدة';

  @override
  String get nurseNavHome => 'الرئيسية';

  @override
  String get nurseNavAvailability => 'اوقات العمل';

  @override
  String get nurseNavAppointments => 'المواعيد';

  @override
  String get nurseNavRequests => 'الطلبات';

  @override
  String get nurseNavProfile => 'الملف';

  @override
  String get nurseRequestsTitle => 'طلبات المرضى';

  @override
  String nurseRequestsPendingCountSubtitle(int count) {
    return '$count طلب قيد الانتظار';
  }

  @override
  String nurseRequestsRejectedCountSubtitle(int count) {
    return '$count طلب مرفوض';
  }

  @override
  String nurseRequestsTabPending(int count) {
    return 'قيد الانتظار ($count)';
  }

  @override
  String nurseRequestsTabRejected(int count) {
    return 'مرفوضة ($count)';
  }

  @override
  String get nurseRequestsEmptyPendingTitle => 'لا توجد طلبات حالياً';

  @override
  String get nurseRequestsEmptyPendingSubtitle =>
      'ستظهر الطلبات الجديدة هنا عند توفرها.';

  @override
  String get nurseRequestsEmptyRejectedTitle => 'لا توجد طلبات حالياً';

  @override
  String get nurseRequestsEmptyRejectedSubtitle =>
      'ستظهر الطلبات هنا عند توفرها.';

  @override
  String get nurseRequestsLoadErrorTitle => 'لم نتمكن من تحميل الطلبات';

  @override
  String get nurseRequestsLoadErrorSubtitle =>
      'تحقق من اتصالك بالإنترنت ثم حاول مرة أخرى.';

  @override
  String get nurseRetry => 'إعادة المحاولة';

  @override
  String get nurseRequestsRejectDialogTitle => 'رفض الطلب';

  @override
  String get nurseRequestsRejectDialogMessage =>
      'هل أنت متأكد أنك تريد رفض هذا الطلب؟';

  @override
  String get nurseDialogNo => 'لا';

  @override
  String get nurseReject => 'رفض';

  @override
  String get nurseAccept => 'قبول';

  @override
  String get nurseRequestsAcceptedSuccess => 'تم قبول الطلب بنجاح.';

  @override
  String get nurseRequestsRejectedSuccess => 'تم رفض الطلب بنجاح.';

  @override
  String nurseRequestsDurationMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String get nurseAvailEmbeddedTitle => 'اوقات العمل';

  @override
  String get nurseAvailManageTitle => 'إدارة أوقات العمل';

  @override
  String get nurseAvailTapDateHint =>
      'جدولك الأسبوعي يتكرر كل أسبوع. اضغط على أي يوم لإيقافه أو تحديد ساعات مخصصة له.';

  @override
  String get nurseAvailLegendWorking => 'متاح للعمل';

  @override
  String get nurseAvailLegendCustomHours => 'ساعات مخصصة';

  @override
  String get nurseAvailLegendBlocked => 'يوم محجوب';

  @override
  String get nurseAvailWeeklySchedule => 'الجدول الأسبوعي';

  @override
  String get nurseAvailAddTimeSlot => 'إضافة وقت عمل';

  @override
  String get nurseAvailNoScheduleYet => 'لا يوجد جدول محدد حتى الآن';

  @override
  String get nurseAvailNoScheduleHint =>
      'اضغط «إضافة وقت عمل» لتحديد ساعات عملك';

  @override
  String get nurseAvailSave => 'حفظ أوقات العمل';

  @override
  String get nurseAvailSaveAutoMessage =>
      'يتم حفظ التغييرات تلقائيًا بعد كل إجراء';

  @override
  String get nurseAvailTimeSlotAdded => 'تمت إضافة الفترة بنجاح';

  @override
  String get nurseAvailDayBlocked => 'تم إيقاف اليوم بنجاح';

  @override
  String get nurseAvailDayUnblocked => 'تم إلغاء إيقاف اليوم بنجاح';

  @override
  String nurseAvailOverrideSuccess(String start, String end) {
    return 'تم تعديل ساعات العمل: $start - $end';
  }

  @override
  String get nurseAvailSlotDeleted => 'تم حذف الفترة بنجاح';

  @override
  String get nurseAvailSlotStatusUpdated => 'تم تحديث حالة الفترة';

  @override
  String get nurseAvailManageDayTitle => 'إدارة اليوم';

  @override
  String get nurseAvailWorkingHours => 'ساعات العمل';

  @override
  String get nurseAvailNoHoursThisDay => 'لا توجد ساعات عمل لهذا اليوم';

  @override
  String get nurseAvailFromWeeklySchedule => 'حسب جدولك الأسبوعي';

  @override
  String get nurseAvailDayBlockedShort => 'هذا اليوم موقوف';

  @override
  String get nurseAvailCustomOverrideApplied => 'تم تطبيق ساعات مخصصة';

  @override
  String get nurseAvailOverrideHoursTitle => 'تعديل ساعات هذا اليوم';

  @override
  String get nurseAvailOverrideHoursSubtitle =>
      'تحديد ساعات مخصصة لهذا اليوم فقط';

  @override
  String get nurseAvailBlockDayTitle => 'إيقاف هذا اليوم';

  @override
  String get nurseAvailUnblockDayTitle => 'إلغاء إيقاف اليوم';

  @override
  String get nurseAvailUnblockDaySubtitle => 'جعل هذا اليوم متاحًا مرة أخرى';

  @override
  String get nurseAvailBlockDaySubtitle =>
      'تحديد هذا اليوم كغير متاح (إجازة مثلاً)';

  @override
  String nurseAvailOverrideHoursForDate(String date) {
    return 'تحديد ساعات مخصصة لـ $date';
  }

  @override
  String get nurseAvailStartTime => 'وقت البدء';

  @override
  String get nurseAvailEndTime => 'وقت الانتهاء';

  @override
  String get nurseAvailCancel => 'إلغاء';

  @override
  String get nurseAvailSaveOverride => 'حفظ التعديل';

  @override
  String get nurseAvailBlockConfirmTitle => 'هل تريد إيقاف هذا اليوم؟';

  @override
  String get nurseAvailBlockConfirmMessage =>
      'لن يتمكن المرضى من حجز مواعيد في هذا اليوم.';

  @override
  String get nurseAvailBlockDay => 'إيقاف اليوم';

  @override
  String get nurseAvailQuickSettingsTitle => 'إعدادات سريعة';

  @override
  String get nurseAvailQuickCopyWeekdays => 'تطبيق على جميع أيام الأسبوع';

  @override
  String get nurseAvailQuickCopyWeekdaysSubtitle =>
      'تطبيق جدول يوم الإثنين على باقي الأيام';

  @override
  String get nurseAvailQuickWeekend => 'تحديد توفر نهاية الأسبوع';

  @override
  String get nurseAvailQuickWeekendSubtitle =>
      'تحديد ساعات العمل ليومي السبت والأحد';

  @override
  String get nurseAvailQuickBlockDays => 'إيقاف أيام محددة';

  @override
  String get nurseAvailQuickBlockDaysSubtitle => 'تحديد الأيام غير المتاحة';

  @override
  String get nurseAvailQuickPlaceholder =>
      'الإعدادات السريعة للواجهة فقط حاليًا';

  @override
  String get nurseAvailQuickBlockHint => 'استخدم التقويم لإيقاف أيام محددة';

  @override
  String get nurseAvailAddWorkingHoursTitle => 'إضافة ساعات العمل';

  @override
  String get nurseAvailAddWorkingHoursSubtitle => 'حدد جدول عملك الأسبوعي';

  @override
  String get nurseAvailSelectDay => 'اختر اليوم';

  @override
  String get nurseAvailSummary => 'الملخص';

  @override
  String get nurseAvailSummaryDay => 'اليوم';

  @override
  String get nurseAvailSummaryHours => 'الساعات';

  @override
  String get nurseAvailSummaryDuration => 'المدة';

  @override
  String get nurseAvailBookingNote =>
      'ملاحظة: سيتم إنشاء مواعيد الحجز تلقائيًا بناءً على ساعات عملك ومدة الخدمات.';

  @override
  String get nurseAvailAddButton => 'إضافة ساعات العمل';

  @override
  String get nurseAvailInvalidTimeRange => 'مدة غير صالحة';

  @override
  String get nurseAvailEndAfterStart =>
      'وقت الانتهاء يجب أن يكون بعد وقت البدء';

  @override
  String get nurseAvailWeekdayMonday => 'الإثنين';

  @override
  String get nurseAvailWeekdayTuesday => 'الثلاثاء';

  @override
  String get nurseAvailWeekdayWednesday => 'الأربعاء';

  @override
  String get nurseAvailWeekdayThursday => 'الخميس';

  @override
  String get nurseAvailWeekdayFriday => 'الجمعة';

  @override
  String get nurseAvailWeekdaySaturday => 'السبت';

  @override
  String get nurseAvailWeekdaySunday => 'الأحد';

  @override
  String nurseAvailSlotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فترة',
      many: '$count فترة',
      few: '$count فترات',
      two: 'فترتان',
      one: 'فترة واحدة',
      zero: 'لا فترات',
    );
    return '$_temp0';
  }

  @override
  String get nurseAvailDeactivateSlot => 'تعطيل الفترة';

  @override
  String get nurseAvailActivateSlot => 'تفعيل الفترة';

  @override
  String get nurseAvailDelete => 'حذف';

  @override
  String get nurseAppointmentsTitle => 'مواعيدي';

  @override
  String nurseAppointmentsTabToday(int count) {
    return 'اليوم ($count)';
  }

  @override
  String nurseAppointmentsTabUpcoming(int count) {
    return 'القادمة ($count)';
  }

  @override
  String nurseAppointmentsTabPast(int count) {
    return 'السابقة ($count)';
  }

  @override
  String get nurseAppointmentsEmpty => 'لا توجد مواعيد حالياً';

  @override
  String get nurseAppointmentsErrorGeneric => 'حدث خطأ ما.';

  @override
  String get nurseLoginRequiredShort => 'يرجى تسجيل الدخول';

  @override
  String get nurseProfileTitle => 'الملف الشخصي';

  @override
  String get nurseProfileSubtitle => 'الحساب والإعدادات';

  @override
  String get nurseProfilePersonalInfoTitle => 'المعلومات الشخصية';

  @override
  String get nurseProfilePersonalInfoSubtitle => 'بياناتك وخدماتك المهنية';

  @override
  String get nurseProfileMyServicesTitle => 'خدماتي';

  @override
  String get nurseProfileMyServicesSubtitle =>
      'أضف أو عدّل الخدمات التي تقدمها';

  @override
  String get nurseProfileRatingsTitle => 'التقييمات';

  @override
  String get nurseProfileRatingsSubtitle => 'تقييمات المرضى';

  @override
  String get nurseProfileEarningsTitle => 'الأرباح';

  @override
  String get nurseProfileEarningsSubtitle => 'الأرباح وسجل المعاملات';

  @override
  String get nurseProfileLogoutTitle => 'تسجيل الخروج';

  @override
  String get nurseProfileLogoutSubtitle => 'تسجيل الخروج من هذا الجهاز';

  @override
  String get nurseProfileLogoutDialogTitle => 'تسجيل الخروج؟';

  @override
  String get nurseProfileLogoutDialogMessage =>
      'ستحتاج إلى تسجيل الدخول مرة أخرى للوصول إلى حسابك.';

  @override
  String nurseProfileLogoutFailed(String error) {
    return 'تعذر تسجيل الخروج: $error';
  }

  @override
  String nursePersonalLoadFailed(String error) {
    return 'تعذر تحميل الملف: $error';
  }

  @override
  String get nursePersonalExperienceInvalid =>
      'سنوات الخبرة يجب أن تكون رقمًا صحيحًا';

  @override
  String get nursePersonalUpdatedSuccess => 'تم تحديث الملف بنجاح';

  @override
  String nursePersonalUpdateFailed(String error) {
    return 'تعذر تحديث الملف: $error';
  }

  @override
  String get nursePersonalHeaderTitle => 'المعلومات الشخصية';

  @override
  String get nursePersonalHeaderSubtitle => 'إدارة بياناتك المهنية';

  @override
  String get nursePersonalSectionPersonal => 'المعلومات الشخصية';

  @override
  String get nursePersonalSectionProfessional => 'البيانات المهنية';

  @override
  String get nursePersonalSaveChanges => 'حفظ التعديلات';

  @override
  String get nursePersonalFullName => 'الاسم الكامل';

  @override
  String get nursePersonalEmail => 'البريد الإلكتروني';

  @override
  String get nursePersonalPhone => 'رقم الهاتف';

  @override
  String get nursePersonalLocation => 'الموقع';

  @override
  String get nursePersonalAddress => 'العنوان';

  @override
  String get nursePersonalNationalId => 'الرقم الوطني';

  @override
  String get nursePersonalBio => 'نبذة';

  @override
  String get nursePersonalLicenseNumber => 'رقم الترخيص';

  @override
  String get nursePersonalSpecialization => 'التخصص';

  @override
  String get nursePersonalExperience => 'الخبرة';

  @override
  String get nursePersonalServicesOffered => 'الخدمات المقدمة';

  @override
  String get nursePersonalNoServicesFound => 'لا توجد خدمات حالياً.';

  @override
  String get nurseServicesAddHint =>
      'اضغط على \"+ إضافة\" أعلاه لإضافة أول خدمة لك';

  @override
  String get nurseServiceAddTitle => 'إضافة خدمة';

  @override
  String get nurseServiceAddSubtitle => 'أضف خدمة تقدمها';

  @override
  String get nurseServiceEditTitle => 'تعديل الخدمة';

  @override
  String get nurseServiceEditSubtitle => 'تحديث سعر خدمتك';

  @override
  String get nurseServiceSelectRequired => 'يرجى اختيار خدمة';

  @override
  String get nurseServicePriceInvalid => 'يرجى إدخال سعر صحيح';

  @override
  String get nurseServiceAddedSuccess => 'تمت إضافة الخدمة بنجاح';

  @override
  String get nurseServiceUpdatedSuccess => 'تم تحديث الخدمة بنجاح';

  @override
  String get nurseServiceDeletedSuccess => 'تم حذف الخدمة بنجاح';

  @override
  String get nurseServiceSelectLabel => 'اختر الخدمة *';

  @override
  String get nurseServiceDurationLabel => 'مدة الخدمة';

  @override
  String get nurseServicePriceLabel => 'سعرك *';

  @override
  String get nurseServicePriceHint => 'أدخل سعرك';

  @override
  String get nurseServicePriceHelp => 'حدد سعرك لهذه الخدمة';

  @override
  String get nurseServiceChooseHint => 'اختر خدمة...';

  @override
  String get nurseServiceSelectFirst => 'اختر خدمة أولاً';

  @override
  String get nurseServiceFixedDuration => '(مدة ثابتة)';

  @override
  String nurseServiceMinutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get nurseServiceCurrencyJod => 'د.أ';

  @override
  String get nurseServiceAddButton => 'إضافة خدمة';

  @override
  String get nurseServiceUpdateButton => 'تحديث الخدمة';

  @override
  String get nurseServiceDeleteTitle => 'حذف الخدمة';

  @override
  String get nurseServiceDeleteConfirm => 'هل أنت متأكد من حذف هذه الخدمة؟';

  @override
  String get nurseServiceNoteTitle => 'ملاحظة:';

  @override
  String get nurseServiceAddNoteBody =>
      'مدة الخدمة تأتي من كتالوج الخدمات في النظام. كل ما عليك اختيار الخدمة وإدخال السعر.';

  @override
  String get nurseServiceEditNoteBody =>
      'مدة الخدمة تأتي من كتالوج الخدمات في النظام. يمكنك تعديل الخدمة المختارة والسعر فقط.';

  @override
  String nurseServiceSummaryService(String name) {
    return 'الخدمة: $name';
  }

  @override
  String nurseServiceSummaryDuration(String value) {
    return 'المدة: $value';
  }

  @override
  String get nurseServiceSummaryPriceLabel => 'سعرك:';

  @override
  String nurseServiceSummaryPriceValue(String price) {
    return '$price د.أ';
  }

  @override
  String nurseRatingsBasedOn(int count) {
    return 'بناءً على $count تقييم';
  }

  @override
  String get nurseRatingsEmpty => 'لا توجد تقييمات بعد';

  @override
  String get nurseRatingsRecentReviews => 'أحدث التقييمات';

  @override
  String get nurseRatingsMockName1 => 'أحمد م.';

  @override
  String get nurseRatingsMockComment1 =>
      'ممرضة متميزة ومنتظمة في المواعيد. أنصح بها جدًا.';

  @override
  String get nurseRatingsMockName2 => 'رانيا ك.';

  @override
  String get nurseRatingsMockComment2 =>
      'تعامل ممتاز في العناية بالجروح وشرح واضح.';

  @override
  String get nurseRatingsMockName3 => 'سارة المصري';

  @override
  String get nurseRatingsMockComment3 => 'زيارة ممتازة وسأقوم بالحجز مرة أخرى.';

  @override
  String get nurseEarningsPlaceholderTitle => 'الأرباح';

  @override
  String get nurseEarningsPlaceholderBody =>
      'ستظهر تفاصيل الأرباح وسجل الدفعات هنا عند ربطها بالنظام.';

  @override
  String get nurseRegTitle => 'تسجيل كممرض';

  @override
  String get nurseRegPhoneLabel => 'رقم الهاتف';

  @override
  String get nurseRegPhoneHint => 'مثال: 079XXXXXXX';

  @override
  String get nurseRegNationalIdLabel => 'الرقم الوطني';

  @override
  String get nurseRegNationalIdHint => 'أدخل الرقم الوطني';

  @override
  String get nurseRegLicenseLabel => 'رقم مزاولة المهنة';

  @override
  String get nurseRegLicenseHint => 'أدخل رقم مزاولة المهنة';

  @override
  String get nurseRegGovernorateLabel => 'المحافظة';

  @override
  String get nurseRegGovernorateSelect => 'اختر المحافظة';

  @override
  String get nurseRegAreaLabel => 'المنطقة / الحي';

  @override
  String get nurseRegAreaHint => 'مثال: عبدون، جبل عمان';

  @override
  String get nurseRegSpecializationLabel => 'التخصص';

  @override
  String get nurseRegSpecializationHint => 'مثال: عناية حثيثة، رعاية كبار السن';

  @override
  String get nurseRegExperienceLabel => 'سنوات الخبرة';

  @override
  String get nurseRegExperienceHint => 'مثال: 5';

  @override
  String get nurseRegBioLabel => 'نبذة عنك';

  @override
  String get nurseRegBioHint => 'اكتب نبذة قصيرة عن خبرتك';

  @override
  String get nurseRegUploadNationalIdTitle => 'رفع صورة الهوية';

  @override
  String get nurseRegUploadLicenseTitle => 'رفع شهادة مزاولة المهنة';

  @override
  String get nurseRegUploadProfileTitle => 'رفع الصورة الشخصية';

  @override
  String get nurseRegUploadImageHint => 'JPG / JPEG / PNG';

  @override
  String get nurseRegUploadPdfHint => 'PDF فقط';

  @override
  String get nurseRegConfirmAccuracy => 'أؤكد أن جميع المعلومات صحيحة';

  @override
  String get nurseRegSubmit => 'إرسال الطلب';

  @override
  String get nurseRegRequiredField => 'حقل مطلوب';

  @override
  String get nurseRegSelectGovernorateError => 'يرجى اختيار المحافظة';

  @override
  String get nurseRegConfirmInfoError => 'يرجى تأكيد صحة المعلومات';

  @override
  String get nurseRegExperienceInvalid =>
      'سنوات الخبرة يجب أن تكون رقمًا صحيحًا';

  @override
  String get nurseRegUploadNationalIdError => 'يرجى رفع صورة الهوية';

  @override
  String get nurseRegUploadLicenseError => 'يرجى رفع شهادة مزاولة المهنة (PDF)';

  @override
  String get nurseRegUploadProfilePhotoError => 'يرجى رفع الصورة الشخصية';

  @override
  String get nurseRegSubmittedSuccess => 'تم إرسال الطلب بنجاح';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsNurseTitle => 'إشعارات الممرض';

  @override
  String get notificationsLoadFailed => 'تعذر تحميل الإشعارات';

  @override
  String get notificationsMarkOneFailed => 'تعذر تعليم الإشعار كمقروء';

  @override
  String get notificationsMarkAllFailed => 'تعذر تعليم كل الإشعارات كمقروءة';

  @override
  String get notificationsNoLinkedScreen => 'لا توجد شاشة مرتبطة بهذا الإشعار';

  @override
  String get notificationsNoBookingLinked => 'لا يوجد حجز مرتبط';

  @override
  String get notificationsOpenDetailsFailed => 'تعذر فتح تفاصيل الموعد';

  @override
  String notificationsUnhandledTarget(String target) {
    return 'شاشة غير مدعومة: $target';
  }

  @override
  String get notificationsReadAll => 'قراءة الكل';

  @override
  String notificationsUnreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إشعار غير مقروء',
      many: '$count إشعارًا غير مقروء',
      few: '$count إشعارات غير مقروءة',
      two: 'إشعاران غير مقروءين',
      one: 'إشعار غير مقروء واحد',
      zero: 'لا توجد إشعارات غير مقروءة',
    );
    return '$_temp0';
  }

  @override
  String get notificationsAllRead => 'كل الإشعارات مقروءة';

  @override
  String get notificationsEmpty => 'لا توجد إشعارات حتى الآن.';

  @override
  String get notificationsJustNow => 'الآن';

  @override
  String notificationsMinAgo(int count) {
    return 'منذ $count دقيقة';
  }

  @override
  String notificationsHoursAgo(int count) {
    return 'منذ $count ساعة';
  }

  @override
  String notificationsDaysAgo(int count) {
    return 'منذ $count يوم';
  }

  @override
  String get notificationsMarkAsRead => 'تعليم كمقروء';

  @override
  String get nurseAppointmentDetailsTitle => 'تفاصيل الموعد';

  @override
  String get nurseAppointmentWaitingBanner =>
      'بانتظار الدفع\nلقد قمت بقبول هذا الموعد. يجب على المريض إكمال الدفع لتفعيله.';

  @override
  String get nurseAppointmentStatusLabel => 'الحالة';

  @override
  String get nurseAppointmentPatientInformation => 'معلومات المريض';

  @override
  String get nurseAppointmentCallPatient => 'اتصال بالمريض';

  @override
  String get nurseAppointmentWhatsAppPatient => 'رسالة عبر واتساب';

  @override
  String get nurseAppointmentDetailsSectionTitle => 'تفاصيل الموعد';

  @override
  String get nurseAppointmentDateLabel => 'التاريخ';

  @override
  String get nurseAppointmentTimeDurationLabel => 'الوقت والمدة';

  @override
  String get nurseAppointmentServiceLocationLabel => 'موقع الخدمة';

  @override
  String get nurseAppointmentYourEarnings => 'أرباحك';

  @override
  String get nurseAppointmentPaymentStatusLabel => 'حالة الدفع';

  @override
  String get nurseAppointmentMarkCompleted => 'تحديد كمكتمل';

  @override
  String get nurseAppointmentCancelTitle => 'إلغاء الموعد';

  @override
  String get nurseAppointmentCancelConfirmMessage =>
      'هل أنت متأكد أنك تريد إلغاء هذا الموعد؟';

  @override
  String get nurseAppointmentCompleteConfirmMessage =>
      'هل أنت متأكد أنك تريد تحديد هذا الموعد كمكتمل؟';

  @override
  String get nurseAppointmentCancelledSuccess => 'تم إلغاء الموعد بنجاح.';

  @override
  String get nurseAppointmentCompletedSuccess => 'تم تحديد الموعد كمكتمل.';

  @override
  String get nurseAppointmentStatusWaitingPayment => 'بانتظار الدفع';

  @override
  String get nurseAppointmentStatusActivePaid => 'نشط / مدفوع';

  @override
  String get nurseAppointmentPaymentPaid => 'مدفوع';

  @override
  String get nurseAppointmentPaymentUnpaid => 'غير مدفوع';

  @override
  String get nurseAppointmentPaymentNotApplicable => 'غير متاح';

  @override
  String get nurseAppointmentServiceFallback => 'الخدمة';

  @override
  String get nurseAppointmentPaymentPendingBannerBody =>
      'المريض لم يُكمل الدفع بعد — يمكنك التواصل معه أو إلغاء الموعد.';

  @override
  String get patientAppointmentDetailsTitle => 'تفاصيل الموعد';

  @override
  String get patientAppointmentNurseInformation => 'معلومات الممرضة';

  @override
  String get patientAppointmentCall => 'اتصال';

  @override
  String get patientAppointmentWhatsApp => 'واتساب';

  @override
  String get patientAppointmentDate => 'التاريخ';

  @override
  String get patientAppointmentTimeDuration => 'الوقت والمدة';

  @override
  String get patientAppointmentAddress => 'العنوان';

  @override
  String get patientAppointmentTotalCost => 'التكلفة الإجمالية';

  @override
  String get patientAppointmentPaymentStatus => 'حالة الدفع';

  @override
  String get patientAppointmentPayNow => 'ادفع الآن';

  @override
  String get patientAppointmentNoActions =>
      'لا توجد إجراءات متاحة لهذا الموعد.';

  @override
  String get patientAppointmentCancelling => 'جاري الإلغاء...';

  @override
  String get patientAppointmentCancelButton => 'إلغاء الموعد';

  @override
  String get patientAppointmentLoadFailed => 'تعذر تحميل تفاصيل الموعد';

  @override
  String get patientAppointmentPayToContinueTitle => 'ادفع للمتابعة';

  @override
  String get patientAppointmentPayToContinueBody =>
      'تم تأكيد موعدك من الممرضة. الرجاء إكمال الدفع لتفعيل الموعد والحفاظ على الحجز.';

  @override
  String get patientAppointmentStatusLabel => 'الحالة';

  @override
  String get patientAppointmentPhoneUnavailable => 'رقم الهاتف غير متوفر.';

  @override
  String get patientAppointmentDialerOpenFailed => 'تعذر فتح تطبيق الاتصال.';

  @override
  String get patientAppointmentWhatsAppOpenFailed => 'تعذر فتح واتساب.';

  @override
  String get patientAppointmentCancelTitle => 'إلغاء الموعد';

  @override
  String get patientAppointmentCancelConfirm =>
      'هل أنت متأكد أنك تريد إلغاء هذا الموعد؟';

  @override
  String get patientAppointmentCancelConfirmAction => 'نعم، إلغاء';

  @override
  String get patientAppointmentCancelledSuccess => 'تم إلغاء الموعد بنجاح.';

  @override
  String patientAppointmentHours(int count) {
    return '$count ساعة';
  }

  @override
  String patientAppointmentMinutes(int count) {
    return '$count دقيقة';
  }

  @override
  String get patientAppointmentPaymentAwaitingNurse => 'بانتظار موافقة الممرضة';

  @override
  String get patientAppointmentPaymentUnpaid => 'غير مدفوع';

  @override
  String get patientAppointmentPaymentPaid => 'مدفوع';

  @override
  String get patientAppointmentPaymentCancelled => 'ملغي';

  @override
  String get patientAppointmentPaymentRejected => 'مرفوض';

  @override
  String get patientNurseProfileAboutTab => 'حول';

  @override
  String patientNurseProfileReviewsTab(int count) {
    return 'التقييمات ($count)';
  }

  @override
  String get patientNurseProfileLocation => 'الموقع';

  @override
  String get patientNurseProfileAvailability => 'التوفر';

  @override
  String get patientNurseProfileServicesOffered => 'الخدمات المتاحة';

  @override
  String get patientNurseProfileNoServicesTitle =>
      'لا توجد خدمات متاحة لهذه الممرضة حالياً.';

  @override
  String get patientNurseProfileNoServicesSubtitle =>
      'لا يمكنك حجز خدمة في الوقت الحالي.';

  @override
  String get patientNurseProfileReviews => 'التقييمات';

  @override
  String get patientNurseProfileReviewsPlaceholder =>
      'ستظهر التقييمات بعد توفرها من الخادم.';

  @override
  String get patientNurseProfileBookServiceRequest => 'حجز طلب خدمة';

  @override
  String get patientNurseProfileNoServicesAvailable => 'لا توجد خدمات متاحة';

  @override
  String get patientRequestServiceTitle => 'طلب خدمة';

  @override
  String get patientRequestStepServiceDetails => 'تفاصيل الخدمة';

  @override
  String get patientRequestStepReviewConfirm => 'المراجعة والتأكيد';

  @override
  String get patientRequestRequiredFields => 'يرجى تعبئة جميع الحقول المطلوبة.';

  @override
  String get patientRequestSelectServiceType => 'اختر نوع الخدمة';

  @override
  String get patientRequestNoServicesForNurse =>
      'لا توجد خدمات متاحة لهذه الممرضة.';

  @override
  String get patientRequestSelectDate => 'اختر التاريخ';

  @override
  String get patientRequestNoAvailableDates => 'لا توجد تواريخ متاحة.';

  @override
  String get patientRequestSelectTimeSlot => 'اختر وقتاً متاحاً';

  @override
  String get patientRequestSelectServiceDateFirst =>
      'اختر الخدمة والتاريخ لعرض الأوقات المتاحة.';

  @override
  String get patientRequestNoAvailableTimeSlots =>
      'لا توجد أوقات متاحة لهذا التاريخ.';

  @override
  String get patientRequestServiceAddress => 'عنوان الخدمة';

  @override
  String get patientRequestAddressHint => 'أدخل عنوانك الكامل';

  @override
  String get patientRequestAdditionalNotesOptional =>
      'ملاحظات إضافية (اختياري)';

  @override
  String get patientRequestNotesHint => 'أي تعليمات خاصة أو معلومات طبية...';

  @override
  String get patientRequestReviewAndConfirm => 'مراجعة وتأكيد';

  @override
  String get patientRequestReviewYourRequest => 'راجع طلبك';

  @override
  String get patientRequestServiceType => 'نوع الخدمة';

  @override
  String get patientRequestDuration => 'المدة';

  @override
  String get patientRequestTime => 'الوقت';

  @override
  String get patientRequestNotes => 'الملاحظات';

  @override
  String get patientRequestServiceCost => 'تكلفة الخدمة';

  @override
  String get patientRequestService => 'الخدمة';

  @override
  String get patientRequestTotalPrice => 'السعر الإجمالي';

  @override
  String get patientRequestSubmitRequest => 'إرسال الطلب';

  @override
  String get patientRequestSubmittedTitle => 'تم إرسال الطلب!';

  @override
  String patientRequestSubmittedBody(String name) {
    return 'تم إرسال طلب الخدمة إلى\n$name. ستصلك إشعار فور رد الممرضة.';
  }

  @override
  String get patientRequestSummary => 'ملخص الطلب';

  @override
  String get patientRequestNurseLabel => 'الممرضة:';

  @override
  String get patientRequestServiceLabel => 'الخدمة:';

  @override
  String get patientRequestDurationLabel => 'المدة:';

  @override
  String get patientRequestDateLabel => 'التاريخ:';

  @override
  String get patientRequestTimeLabel => 'الوقت:';

  @override
  String get patientRequestTotalPriceLabel => 'السعر الإجمالي:';

  @override
  String get patientRequestBackToNurses => 'العودة إلى الممرضات';

  @override
  String get statusBannerNursePending => 'هذا الحجز بانتظار ردك.';

  @override
  String get statusBannerPatientPending => 'طلبك بانتظار التأكيد.';

  @override
  String get statusBannerConfirmed => 'تم تأكيد الموعد. نراك في الوقت المحدد.';

  @override
  String get statusBannerNurseWaitingPayment => 'الدفع ما زال بانتظار المريض.';

  @override
  String get statusBannerPatientWaitingPayment =>
      'يرجى إكمال الدفع لتأكيد هذا الموعد.';

  @override
  String get statusBannerPaid => 'تم استلام الدفع. الموعد أصبح نشطًا.';

  @override
  String get statusBannerCompleted => 'تم إكمال هذا الموعد.';

  @override
  String get statusBannerCancelled => 'تم إلغاء هذا الموعد.';

  @override
  String get statusBannerRejected => 'لم يتم قبول هذا الطلب.';

  @override
  String get paymentSuccessTitle => 'تم الدفع بنجاح';

  @override
  String paymentSuccessAmountPaid(String amount) {
    return 'المبلغ المدفوع: $amount';
  }

  @override
  String get paymentBackToAppointments => 'العودة إلى المواعيد';

  @override
  String get paymentFailedTitle => 'فشل الدفع';

  @override
  String get paymentFailedBody =>
      'تعذر إتمام عملية الدفع. يرجى المحاولة مرة أخرى.';

  @override
  String get paymentRetryButton => 'إعادة المحاولة';

  @override
  String get forgotTitle => 'نسيت كلمة المرور';

  @override
  String get forgotEnterEmail => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get forgotEnterValidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get forgotServerTimeoutMessage =>
      'استغرقت استجابة الخادم وقتًا طويلًا. تحقق من الإعدادات وحاول مرة أخرى.';

  @override
  String get forgotResetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotResetPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get forgotResetLinkHint =>
      'سنرسل رابط إعادة التعيين إلى بريدك الإلكتروني.';

  @override
  String get forgotSendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get nurseResubmitTitle => 'إعادة إرسال التحقق';

  @override
  String get nurseResubmitNoFileSelected => 'لم يتم اختيار ملف';

  @override
  String get nurseResubmitExperienceInvalid =>
      'سنوات الخبرة يجب أن تكون رقمًا صالحًا';

  @override
  String get nurseResubmitSubmittedSuccess =>
      'تمت إعادة الإرسال بنجاح. بانتظار موافقة الإدارة.';

  @override
  String nurseResubmitSubmitFailed(String error) {
    return 'فشل الإرسال: $error';
  }

  @override
  String get nurseResubmitUpdateDetailsTitle => 'تحديث بياناتك';

  @override
  String get nurseResubmitUpdateDetailsSubtitle =>
      'عدّل العناصر المطلوبة ثم أعد إرسال معلوماتك.\nبعد الإرسال ستعود حالتك إلى قيد المراجعة.';

  @override
  String get nurseResubmitPhoneRequired => 'رقم الهاتف مطلوب';

  @override
  String get nurseResubmitPhoneInvalid => 'أدخل رقم هاتف صحيح';

  @override
  String get nurseResubmitAddressRequired => 'العنوان مطلوب';

  @override
  String get nurseResubmitLocationHint => 'المدينة / الموقع (مثال: عمّان)';

  @override
  String get nurseResubmitLocationRequired => 'الموقع مطلوب';

  @override
  String get nurseResubmitNationalIdRequired => 'الرقم الوطني مطلوب';

  @override
  String get nurseResubmitNationalIdInvalid => 'أدخل رقمًا وطنيًا صحيحًا';

  @override
  String get nurseResubmitLicenseRequired => 'رقم الترخيص مطلوب';

  @override
  String get nurseResubmitSpecializationRequired => 'التخصص مطلوب';

  @override
  String get nurseResubmitExperienceRequired => 'سنوات الخبرة مطلوبة';

  @override
  String get nurseResubmitEnterValidNumber => 'أدخل رقمًا صحيحًا';

  @override
  String get nurseResubmitDocumentsTitle => 'المستندات';

  @override
  String get nurseResubmitDocumentsSubtitle => 'ارفع الملفات المحدثة المطلوبة.';

  @override
  String get nurseResubmitNationalIdTitle => 'الهوية الوطنية';

  @override
  String get nurseResubmitNationalIdHint => 'ارفع الهوية الوطنية (صورة/PDF)';

  @override
  String get nurseResubmitLicenseTitle => 'ترخيص التمريض';

  @override
  String get nurseResubmitLicenseHint => 'ارفع الترخيص (صورة/PDF)';

  @override
  String get nurseResubmitProfilePhotoTitle => 'الصورة الشخصية';

  @override
  String get nurseResubmitProfilePhotoHint => 'ارفع صورة شخصية';

  @override
  String get nurseResubmitChoose => 'اختيار';

  @override
  String get nurseResubmitSubmitForReview => 'إرسال للمراجعة';

  @override
  String nurseAvailDurationHoursMinutes(int hours, int minutes) {
    return '$hoursس $minutesد';
  }

  @override
  String patientOnboardStepOfFour(int step) {
    return 'الخطوة $step من 4';
  }

  @override
  String get patientOnboardSkipForNow => 'تخطّي الآن';

  @override
  String get patientOnboardNext => 'التالي';

  @override
  String get patientOnboardGetStarted => 'ابدأ';

  @override
  String get patientOnboardPersonalTitle => 'المعلومات الشخصية';

  @override
  String get patientOnboardPersonalSubtitle =>
      'اختياري — يمكنك التخطي وإكماله لاحقًا.';

  @override
  String get patientOnboardSelectGender => 'اختر الجنس';

  @override
  String get patientOnboardSelectDate => 'اختر التاريخ';

  @override
  String get patientOnboardSelectBloodType => 'اختر فصيلة الدم';

  @override
  String get patientOnboardAddressTitle => 'العنوان';

  @override
  String get patientOnboardAddressSubtitle =>
      'اختياري — يساعد الممرضين على الوصول إليك بسرعة.';

  @override
  String get patientOnboardAreaHint => 'مثال: عبدون، الجبيهة';

  @override
  String get patientOnboardStreetLabel => 'الشارع / تفاصيل المبنى';

  @override
  String get patientOnboardStreetHint => 'الشقة، المبنى، معالم قريبة';

  @override
  String get patientOnboardMedicalTitle => 'المعلومات الطبية';

  @override
  String get patientOnboardMedicalSubtitle => 'اختياري — شارك فقط ما يريحك.';

  @override
  String get patientOnboardConditionsSection => 'الحالات الصحية';

  @override
  String get patientOnboardConditionsHint =>
      'اختر ما ينطبق. لا يمكن الجمع بين «لا يوجد» وحالات أخرى.';

  @override
  String get patientOnboardOtherConditionLabel => 'حالة أخرى (اختياري)';

  @override
  String get patientOnboardOtherConditionHint => 'مثال: سرطان، أمراض الكلى';

  @override
  String get patientOnboardAllergiesSection => 'الحساسية';

  @override
  String get patientOnboardAllergiesHint =>
      'اضغط على الحساسيات الشائعة أو أضف حساسيتك أدناه.';

  @override
  String get patientOnboardOtherAllergiesLabel => 'حساسيات أخرى (اختياري)';

  @override
  String get patientOnboardOtherAllergiesHint =>
      'مثال: السلفا، المكسرات، المأكولات البحرية';

  @override
  String get patientOnboardNotes => 'ملاحظات';

  @override
  String get patientOnboardNotesHint =>
      'أي معلومات إضافية يجب أن يعرفها فريق الرعاية...';

  @override
  String get paymentBillingTitle => 'المدفوعات والفواتير';

  @override
  String get paymentTotalSpent => 'إجمالي الإنفاق';

  @override
  String get paymentPendingLabel => 'معلق';

  @override
  String get paymentTransactionHistoryTitle => 'سجل المعاملات';

  @override
  String get paymentTransactionHistorySubtitle => 'عرض جميع المدفوعات';

  @override
  String get paymentMethodsTitle => 'طرق الدفع';

  @override
  String get paymentMethodsSubtitle => 'إدارة بطاقاتك';

  @override
  String get paymentRecentTransactions => 'المعاملات الأخيرة';

  @override
  String get paymentViewAll => 'عرض الكل';

  @override
  String get paymentStatusCompleted => 'مكتملة';

  @override
  String get paymentStatusPending => 'معلقة';

  @override
  String get paymentPrimaryLabel => 'أساسية';

  @override
  String get paymentAddNewMethod => 'إضافة طريقة دفع جديدة';

  @override
  String get paymentSupportedMethods => 'طرق الدفع المدعومة';

  @override
  String get paymentCreditDebitCards => 'بطاقات الائتمان/الخصم';

  @override
  String get paymentCashComingSoon => 'نقداً (قريباً)';

  @override
  String get paymentAddNewCard => 'إضافة بطاقة جديدة';

  @override
  String get paymentAddNewCardSubtitle => 'متاح في تحديث قادم';

  @override
  String get paymentCashSubtitle => 'الدفع عند الزيارة';

  @override
  String get paymentComingSoon => 'قريباً';

  @override
  String get paymentNoTransactions => 'لا توجد معاملات بعد.';

  @override
  String get patientMoreReportIssueTitle => 'الإبلاغ عن مشكلة';

  @override
  String get patientMoreReportIssueSubtitle => 'الإبلاغ عن شكوى أو مخاوف';

  @override
  String get reportIssueTitle => 'الإبلاغ عن مشكلة';

  @override
  String get reportIssueCategoryLabel => 'الفئة';

  @override
  String get reportIssueCategoryHint => 'اختر فئة';

  @override
  String get reportIssueSubjectLabel => 'الموضوع';

  @override
  String get reportIssueSubjectHint => 'أدخل الموضوع';

  @override
  String get reportIssueDescriptionLabel => 'الوصف التفصيلي';

  @override
  String get reportIssueDescriptionHint => 'اصف المشكلة بالتفصيل...';

  @override
  String get reportIssueMarkUrgent => 'تحديد كأولوية عاجلة';

  @override
  String get reportIssueUrgentSubtitle => 'هذا الأمر يتطلب اهتماماً فورياً';

  @override
  String get reportIssueNoticeTitle => 'تنبيه مهم';

  @override
  String get reportIssueNoticeBody =>
      'البلاغات الكاذبة تُعامل بجدية تامة وقد تؤدي إلى تعليق الحساب. يرجى التأكد من أن جميع المعلومات المقدمة دقيقة وصحيحة.';

  @override
  String get reportIssueSubmit => 'إرسال البلاغ';

  @override
  String get reportIssueCancel => 'إلغاء';

  @override
  String get reportIssueFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get reportIssueCategoryRequired => 'يرجى اختيار فئة';

  @override
  String get reportIssueCatLateArrival => 'التأخر في الوصول';

  @override
  String get reportIssueCatUnprofessional => 'سلوك غير مهني';

  @override
  String get reportIssueCatPoorService => 'جودة خدمة رديئة';

  @override
  String get reportIssueCatCommunication => 'مشاكل في التواصل';

  @override
  String get reportIssueCatHygiene => 'مخاوف تتعلق بالنظافة';

  @override
  String get reportIssueCatBillingDispute => 'نزاع في الفوترة';

  @override
  String get reportIssueCatInappropriate => 'سلوك غير لائق';

  @override
  String get reportIssueCatHarassment => 'تحرش أو مضايقة';

  @override
  String get reportIssueCatSafety => 'مخاوف تتعلق بالسلامة';

  @override
  String get reportIssueCatFraud => 'احتيال أو نصب';

  @override
  String get reportIssueCatViolence => 'عنف أو تهديدات';

  @override
  String get reportIssueCatOtherSerious => 'مشكلة خطيرة أخرى';

  @override
  String get reportIssueCatOther => 'أخرى';

  @override
  String get patientReportCatTechnical => 'Technical';

  @override
  String get patientReportCatPayment => 'Payment';

  @override
  String get patientReportCatServiceIssue => 'Service Issue';

  @override
  String get patientReportCatAccount => 'Account';

  @override
  String get patientReportCatOther => 'Other';

  @override
  String get patientReportSubmittedSuccess => 'Issue submitted successfully';

  @override
  String get nurseEarningsSubtitle => 'تتبع دخلك';

  @override
  String get nurseEarningsTotalLabel => 'إجمالي الأرباح';

  @override
  String get nurseEarningsThisMonthLabel => 'أرباح هذا الشهر';

  @override
  String get nurseEarningsPendingLabel => 'المبلغ المعلق';

  @override
  String get nurseEarningsAwaitingPayment => 'في انتظار اكتمال الدفع';

  @override
  String get nurseEarningsTabAll => 'جميع الأرباح';

  @override
  String get nurseEarningsTabThisMonth => 'هذا الشهر';

  @override
  String get nurseEarningsTabHistory => 'السجل';

  @override
  String get nurseEarningsRecords => 'سجلات الأرباح';

  @override
  String get nurseEarningsCompletedServices => 'خدمة مكتملة';

  @override
  String get nurseEarningsServicesThisMonth => 'خدمات هذا الشهر';

  @override
  String get nurseEarningsEmpty => 'لا توجد سجلات أرباح بعد.';

  @override
  String get nurseProfileReportTitle => 'الإبلاغ عن مشكلة';

  @override
  String get nurseProfileReportSubtitle =>
      'الإبلاغ عن مشكلة تقنية أو في الخدمة';

  @override
  String get nurseReportTitle => 'الإبلاغ عن مشكلة';

  @override
  String get nurseReportCategoryLabel => 'فئة المشكلة';

  @override
  String get nurseReportCategoryHint => 'اختر فئة';

  @override
  String get nurseReportSubjectLabel => 'الموضوع';

  @override
  String get nurseReportSubjectHint => 'أدخل الموضوع';

  @override
  String get nurseReportDescriptionLabel => 'الوصف التفصيلي';

  @override
  String get nurseReportDescriptionHint => 'اصف المشكلة بالتفصيل...';

  @override
  String get nurseReportMarkUrgent => 'تحديد كأولوية عاجلة';

  @override
  String get nurseReportUrgentSubtitle => 'هذا الأمر يتطلب اهتماماً فورياً';

  @override
  String get nurseReportNoticeTitle => 'تنبيه مهم';

  @override
  String get nurseReportNoticeBody =>
      'البلاغات الكاذبة تُعامل بجدية وقد تؤدي إلى تعليق الحساب. يُرجى الإبلاغ عن المشكلات الحقيقية فقط.';

  @override
  String get nurseReportSubmittedSuccess =>
      'Problem report submitted successfully.';

  @override
  String get nurseReportSubmit => 'إرسال البلاغ';

  @override
  String get nurseReportCancel => 'إلغاء';

  @override
  String get nurseReportFieldRequired => 'هذا الحقل مطلوب';

  @override
  String get nurseReportCategoryRequired => 'يرجى اختيار فئة';

  @override
  String get nurseReportCatPayment => 'مشكلة في الدفع';

  @override
  String get nurseReportCatTechnical => 'مشكلة تقنية';

  @override
  String get nurseReportCatPatient => 'مشكلة مع المريض';

  @override
  String get nurseReportCatSafety => 'مخاوف تتعلق بالسلامة';

  @override
  String get nurseReportCatBug => 'خلل في المنصة';

  @override
  String get nurseReportCatAccount => 'مشكلة في الحساب';

  @override
  String get nurseReportCatScheduling => 'مشكلة في الجدولة';

  @override
  String get nurseReportCatOther => 'أخرى';

  @override
  String get emailDomainSuffix => '@nursenow.com';

  @override
  String get emailLocalPartHint => 'اسم.المستخدم';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordSubtitle =>
      'أدخل رمز التحقق المُرسَل إلى بريدك الإلكتروني وعيّن كلمة مرور جديدة.';

  @override
  String get resetPasswordCodeLabel => 'رمز التحقق';

  @override
  String get resetPasswordCodeHint => 'أدخل الرمز من بريدك الإلكتروني';

  @override
  String get resetPasswordNewLabel => 'كلمة المرور الجديدة';

  @override
  String get resetPasswordNewHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get resetPasswordConfirmLabel => 'تأكيد كلمة المرور';

  @override
  String get resetPasswordConfirmHint => 'أعد إدخال كلمة المرور الجديدة';

  @override
  String get resetPasswordButton => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordCodeRequired => 'رمز التحقق مطلوب';

  @override
  String get resetPasswordMinLength =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get resetPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get resetPasswordSuccess =>
      'تمت إعادة تعيين كلمة المرور بنجاح. يرجى تسجيل الدخول.';

  @override
  String get welcomeDialogTitle => 'أنت جاهز تمامًا!';

  @override
  String get welcomeDialogBody =>
      'ملفك الشخصي جاهز. ابدأ الاستكشاف واحجز أول موعد مع ممرضتك.';

  @override
  String get welcomeDialogButton => 'انتقل إلى لوحة التحكم';

  @override
  String get onboardingPage1Title => 'Professional Home\nNursing Care';

  @override
  String get onboardingPage1Desc =>
      'Connect with verified registered nurses\nfor quality healthcare services in the\ncomfort of your home';

  @override
  String get onboardingPage2Title => 'Verified & Trusted\nNurses';

  @override
  String get onboardingPage2Desc =>
      'All nurses are licensed professionals,\nbackground-checked and verified by\nour admin team';

  @override
  String get onboardingPage3Title => 'Book Anytime,\nAnywhere';

  @override
  String get onboardingPage3Desc =>
      'Schedule nursing services 24/7 with\ninstant booking confirmations and\nreal-time updates';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingNext => 'Next  >';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get nursePendingTitle => 'Application Under Review';

  @override
  String get nursePendingDescription =>
      'Thank you for registering as a nurse.\nYour application is currently being reviewed by the admin.\n\nYou will be notified once your account is approved.';

  @override
  String get nursePendingReviewTime => 'Estimated review time: 24–48 hours';

  @override
  String get nursePendingLogout => 'Log out';

  @override
  String get nurseRejectedVerificationResult => 'Verification Result';

  @override
  String get nurseRejectedTitle => 'Verification Rejected';

  @override
  String get nurseRejectedSubtitle =>
      'Your profile needs updates before\napproval.';

  @override
  String get nurseRejectedReason => 'Reason';

  @override
  String get nurseRejectedRejectionReason =>
      'Your uploaded license is unclear.\nPlease re-upload a clear document with\nall details visible.';

  @override
  String get nurseRejectedUpdateResubmit => 'Update & Resubmit';

  @override
  String get nurseRejectedLogout => 'Logout';
}
