// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Nayza Vocab';

  @override
  String get homeTitle => 'تأكد من معرفتك!';

  @override
  String get homeSubtitle => 'اختر مجموعاتك وابدأ الاختبار.';

  @override
  String get startTest => 'بدء الاختبار';

  @override
  String get matchingGame => 'لعبة المطابقة';

  @override
  String get manageCollections => 'إدارة المجموعات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get history => 'المجموعات';

  @override
  String get collections => 'المجموعات';

  @override
  String get difficultWordsTitle => 'كلمات صعبة';

  @override
  String difficultWordsSubtitle(int count) {
    return 'لديك $count كلمات فشلت فيها';
  }

  @override
  String difficultSetTitle(int number) {
    return 'كلمات صعبة #$number';
  }

  @override
  String get removeFromDifficult => 'إزالة من قائمة الكلمات الصعبة';

  @override
  String get noDifficultWords => 'لا توجد كلمات صعبة بعد. استمر في التدريب!';

  @override
  String get myCollectionsHeader => 'مجموعاتي';

  @override
  String get difficultCollectionsHeader => 'مجموعات صعبة';

  @override
  String get muteOn => 'إلغاء كتم الصوت';

  @override
  String get muteOff => 'كتم الصوت';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get export => 'مشاركة أو نسخة احتياطية';

  @override
  String get exportSubtitle => 'اختر المجموعات للمشاركة أو إنشاء نسخة احتياطية';

  @override
  String get import => 'إضافة كلمات أو استعادة';

  @override
  String get importSubtitle => 'تحميل المجموعات من ملف نسخة احتياطية (JSON)';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get dailyReminder => 'تذكير يومي';

  @override
  String reminderSubtitle(String time) {
    return 'تذكير يومي في $time';
  }

  @override
  String get reminderDefault => 'تذكير بالكلمات الصعبة يومياً';

  @override
  String reminderSetSuccess(Object time) {
    return 'تم تعيين التذكير اليومي في $time';
  }

  @override
  String get appInfo => 'معلومات التطبيق';

  @override
  String get appVersion => 'Nayza Vocab v1.0.1\nCreated for Nayzadorlar 🔱';

  @override
  String get language => 'اللغة';

  @override
  String get uzbek => 'الأوزبكية';

  @override
  String get russian => 'الروسية';

  @override
  String get english => 'الإنجليزية';

  @override
  String importSuccess(Object count) {
    return 'تم استيراد $count مجموعات بنجاح';
  }

  @override
  String importError(Object error) {
    return 'خطأ في الاستيراد: $error';
  }

  @override
  String get historyTitle => 'مجموعاتي';

  @override
  String get searchHint => 'البحث عن مجموعة أو كلمة...';

  @override
  String get noResults => 'لم يتم العثور على نتائج';

  @override
  String get noCollections => 'لا توجد مجموعات بعد';

  @override
  String get collectionsLabel => 'المجموعات';

  @override
  String get foundWordsLabel => 'الكلمات الموجودة';

  @override
  String get editWord => 'تعديل الكلمة';

  @override
  String get editSetTitle => 'إعادة تسمية المجموعة';

  @override
  String get originalWord => 'الكلمة الأصلية';

  @override
  String get translationWord => 'الترجمة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get wordUpdated => 'تم تحديث الكلمة';

  @override
  String wordCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count كلمات',
      one: 'كلمة واحدة',
    );
    return '$_temp0';
  }

  @override
  String setsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مجموعات',
      one: 'مجموعة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get selectCollectionsTitle => 'اختر المجموعات';

  @override
  String get emptyCollectionsWarning =>
      'يجب عليك إنشاء مجموعة واحدة على الأقل أولاً.';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deselectAll => 'إلغاء تحديد الكل';

  @override
  String get selectToStart => 'اختر للبدء';

  @override
  String get emptySelectionWarning => 'المجموعات المختارة فارغة!';

  @override
  String get quizSetupTitle => 'إعداد الاختبار';

  @override
  String get selectQuizMode => 'اختر وضع الاختبار';

  @override
  String get selectDirection => 'اتجاه الاختبار';

  @override
  String get start => 'بدء';

  @override
  String get choiceMode => 'اختيار من متعدد';

  @override
  String get choiceSubtitle => 'اختر من بين 4 خيارات';

  @override
  String get inputMode => 'كتابة';

  @override
  String get inputSubtitle => 'اكتب الإجابة بنفسك';

  @override
  String get flashcardMode => 'بطاقة تعليمية';

  @override
  String get flashcardSubtitle => 'تكرار كلاسيكي';

  @override
  String get matchingMode => 'مطابقة';

  @override
  String get matchingSubtitle => 'جد الأزواج';

  @override
  String get originalToTranslation => 'الأصل -> الترجمة';

  @override
  String get translationToOriginal => 'الترجمة -> الأصل';

  @override
  String get randomDirection => 'مختلط (عشوائي)';

  @override
  String get originalToTranslationSubtitle => 'مثال: الإنجليزية -> الأوزبكية';

  @override
  String get translationToOriginalSubtitle => 'مثال: الأوزبكية -> الإنجليزية';

  @override
  String get randomDirectionSubtitle => 'التبديل عشوائياً';

  @override
  String correctAnswerLabel(String answer) {
    return 'الإجابة الصحيحة: $answer';
  }

  @override
  String get typeTranslationHint => 'اكتب الترجمة...';

  @override
  String get summaryTitle => 'ملخص الاختبار';

  @override
  String scoreLabel(int score) {
    return 'درجتك: $score';
  }

  @override
  String correctCountLabel(Object count) {
    return 'صحيح: $count';
  }

  @override
  String incorrectCountLabel(Object count) {
    return 'خطأ: $count';
  }

  @override
  String get finish => 'إنهاء';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String learnedWordsCount(Object count) {
    return 'لقد أتقنت $count كلمات في هذه الجلسة!';
  }

  @override
  String get flashcardLabel => 'بطاقة تعليمية';

  @override
  String get knowWord => 'أعرف';

  @override
  String get dontKnowWord => 'لا أعرف';

  @override
  String get matchingGameTitle => 'لعبة المطابقة';

  @override
  String get findPairsLabel => 'جد الأزواج';

  @override
  String stageLabel(int count) {
    return 'المرحلة $count';
  }

  @override
  String get gameOverTitle => 'انتهت اللعبة!';

  @override
  String get createSetTitle => 'مجموعة جديدة';

  @override
  String get collectionNameLabel => 'اسم المجموعة';

  @override
  String get collectionNameHint => 'مثال: السفر، العائلة...';

  @override
  String get nameRequiredError => 'يرجى إدخال اسم';

  @override
  String get languageLabel => 'لغة التعلم';

  @override
  String get englishLang => 'الإنجليزية';

  @override
  String get arabicLang => 'العربية';

  @override
  String get russianLang => 'الروسية';

  @override
  String get uzbekLang => 'الأوزبكية';

  @override
  String get germanLang => 'الألمانية';

  @override
  String get koreanLang => 'الكورية';

  @override
  String get wordPlaceholder => 'كلمة';

  @override
  String get translationPlaceholder => 'ترجمة';

  @override
  String get addRowButton => 'إضافة صف';

  @override
  String get atLeastOneWordWarning => 'أدخل كلمة واحدة على الأقل';

  @override
  String get setNotFound => 'المجموعة غير موجودة.';

  @override
  String get deleteSetTitle => 'حذف المجموعة';

  @override
  String deleteSetConfirmation(String title) {
    return 'هل أنت متأكد أنك تريد حذف \"$title\"؟';
  }

  @override
  String get delete => 'حذف';

  @override
  String get addWord => 'إضافة كلمة';

  @override
  String get emptySetWarning => 'هذه المجموعة فارغة.';

  @override
  String wordsFoundCount(int count) {
    return '$count كلمات متاحة';
  }

  @override
  String get masteryExplanation => 'تعتبر الكلمة متقنة after إجابة صحيحة واحدة';

  @override
  String get progressLabel => 'التقدم';

  @override
  String get selectSetsTitle => 'اختر المجموعات';

  @override
  String get selectAtLeastOneSet => 'يرجى اختيار مجموعة واحدة على الأقل.';

  @override
  String get exportSuccess => 'تم التصدير بنجاح!';

  @override
  String get shareSuccess => 'تمت مشاركة المجموعة بنجاح!';

  @override
  String shareSubject(Object title) {
    return 'NayzaVocab: $title';
  }

  @override
  String shareMessage(Object count, Object lang, Object title) {
    return '📚 مجموعة Nayza Vocab: $title\n🌐 اللغة: $lang\n📝 الكلمات: $count\n\nاستورد هذا الملف في Nayza Vocab للتعلم معاً!';
  }

  @override
  String get importedSuffix => '(مستورد)';

  @override
  String exportError(String error) {
    return 'خطأ في التصدير: $error';
  }

  @override
  String wordsCountLabel(int count) {
    return '$count كلمات';
  }

  @override
  String exportAction(Object count) {
    return 'تصدير ($count)';
  }

  @override
  String get onboardingWelcome => 'مرحباً بك في NAYZA VOCAB';

  @override
  String get onboardingPage1Title => 'أتقن مفرداتك';

  @override
  String get onboardingPage1Subtitle =>
      'أقوى طريقة لتعلم وتذكر الكلمات الجديدة بطرق مدعومة علمياً.';

  @override
  String get onboardingPage2Title => 'بطاقات تعليمية وألعاب';

  @override
  String get onboardingPage2Subtitle =>
      'اختبارات تفاعلية وألعاب مطابقة مصممة لجعل التعلم ممتعاً.';

  @override
  String get onboardingPage3Title => 'تتبع تقدمك';

  @override
  String get onboardingPage3Subtitle =>
      'شاهد تحسنك بمرور الوقت وركز على الكلمات الصعبة.';

  @override
  String get onboardingGetStarted => 'ابدأ الآن';

  @override
  String get skip => 'تخطي';

  @override
  String get submitAnswer => 'إرسال';

  @override
  String get collectionsPageTitle => 'المجموعات';

  @override
  String get cancelReminder => 'إلغاء التذكير';

  @override
  String get resetAllData => 'إعادة تعيين كافة البيانات';

  @override
  String get resetAllDataConfirm =>
      'سيؤدي هذا إلى حذف جميع مجموعاتك وتقدمك بشكل دائم. هل أنت متأكد؟';

  @override
  String get deleteSetConfirm => 'هل تريد حذف هذه المجموعة؟';

  @override
  String get communityAndUpdates => 'المجتمع والتحديثات';

  @override
  String get telegramChannel => 'قناة تيليجرام';

  @override
  String get telegramSubtitle => 'انضم للحصول على نصائح وتحديثات وموارد';

  @override
  String get checkForUpdates => 'التحقق من وجود تحديثات';

  @override
  String get checkForUpdatesSubtitle => 'احصل على أحدث إصدار من Nayza Vocab';

  @override
  String get onboardingPage4Title => 'كيف يعمل؟';

  @override
  String get onboardingPage4Subtitle =>
      'أتقن الكلمات من خلال التكرار المنتظم. الكلمات الصعبة تعود بشكل متكرر حتى تحفظها عن ظهر قلب.';

  @override
  String get library => 'المكتبة';

  @override
  String get createFolder => 'مجلد جديد';

  @override
  String get folderName => 'اسم المجلد';

  @override
  String get create => 'إنشاء';

  @override
  String get enterFolderName => 'أدخل اسم المجلد';

  @override
  String get noFolder => 'خارج المجلد (الرئيسي)';

  @override
  String get uncategorized => 'غير مصنف';

  @override
  String get dangerZone => 'منطقة الخطر';

  @override
  String shareError(Object error) {
    return 'خطأ في المشاركة: $error';
  }

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get onlineLibraryTitle => 'مكتبة نايزا السحابية';

  @override
  String get allTopics => 'جميع المواضيع';

  @override
  String wordCountLabel_short(Object count) {
    return '$count كلمات';
  }

  @override
  String get downloadAll => 'تحميل الكل';

  @override
  String get installed => 'تم التثبيت';

  @override
  String get downloading => 'جاري التحميل...';

  @override
  String get deleteFolderConfirm =>
      'حذف هذا المجلد سيؤدي أيضاً إلى حذف جميع مجموعاته وكلماته. هل أنت متأكد؟';

  @override
  String get connectionError => 'خطأ في الاتصال';

  @override
  String get noInternetMessage =>
      'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get noResultsFound => 'لم يتم العثور على نتائج';

  @override
  String get clearFilters => 'مسح التصفية';

  @override
  String get all => 'الكل';

  @override
  String get allDataCleared => 'تم مسح جميع البيانات بنجاح!';

  @override
  String get share => 'مشاركة';

  @override
  String get home => 'الرئيسية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get userName => 'اسم المستخدم';

  @override
  String get userAge => 'العمر';

  @override
  String get targetLanguage => 'اللغة المستهدفة';

  @override
  String get folderBreakdown => 'تحليل المجلدات واللغات';

  @override
  String get subjectBreakdown => 'تفاصيل المجموعات';

  @override
  String yearsOld(int age) {
    return '$age سنة';
  }

  @override
  String get masteredWords => 'متقن';

  @override
  String get smartPasteTitle => 'لصق ذكي';

  @override
  String get smartPasteHint => 'كلمة - ترجمة\nكلمة أخرى = ترجمة أخرى';

  @override
  String get userNameHint => 'اسمك';

  @override
  String get invalidAgeError => 'يرجى إدخال عمر صحيح (1-120)';

  @override
  String get folders => 'مجلدات';

  @override
  String masteredPercentage(int percentage) {
    return '$percentage% متقن';
  }

  @override
  String get showLess => 'عرض أقل';

  @override
  String showAllWithCount(int count) {
    return 'الكل ($count)';
  }

  @override
  String get rankNovice => '🛡️ محارب مبتدئ';

  @override
  String get rankAdvanced => '⚔️ مقاتل متقدم';

  @override
  String get rankCommander => '🔱 قائد نايزا';

  @override
  String get rankWordMaster => '👑 سيد الكلمات';

  @override
  String get latestVersionInstalled => 'لديك أحدث إصدار مثبت';

  @override
  String get updateAvailable => 'يتوفر تحديث جديد';

  @override
  String get updateNow => 'تحديث الآن';

  @override
  String get downloadingUpdate => 'جارٍ تنزيل التحديث...';

  @override
  String get updateCheckFailed => 'فشل التحقق من وجود تحديثات';

  @override
  String get whatsNew => 'ما الجديد';

  @override
  String get openInBrowser => 'تنزيل من المتصفح';

  @override
  String get audioSpeed => 'سرعة النطق';

  @override
  String get speedSlow => 'بطيء (0.75x)';

  @override
  String get speedNormal => 'عادي (1.0x)';

  @override
  String get speedFast => 'سريع (1.25x)';
}
