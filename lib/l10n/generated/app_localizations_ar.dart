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
  String get homeTitle => 'تحقق من معرفتك!';

  @override
  String get homeSubtitle => 'اختر مجموعاتك وابدأ الاختبار.';

  @override
  String get startTest => 'ابدأ الاختبار';

  @override
  String get matchingGame => 'لعبة المطابقة';

  @override
  String get manageCollections => 'إدارة المجموعات';

  @override
  String get settings => 'الإعدادات';

  @override
  String get history => 'السجل';

  @override
  String get collections => 'المجموعات';

  @override
  String get difficultWordsTitle => 'كلمات صعبة';

  @override
  String difficultWordsSubtitle(int count) {
    return 'لديك $count كلمات صعبة';
  }

  @override
  String difficultSetTitle(int number) {
    return 'الكلمات الصعبة #$number';
  }

  @override
  String get removeFromDifficult => 'إزالة من قائمة الكلمات الصعبة';

  @override
  String get noDifficultWords =>
      'لا توجد كلمات صعبة حتى الآن. استمر في التدريب!';

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
  String get export => 'تصدير (نسخة احتياطية)';

  @override
  String get exportSubtitle => 'تحديد ونسخ المجموعات احتياطياً';

  @override
  String get import => 'استيراد (استعادة)';

  @override
  String get importSubtitle => 'تحميل المجموعات من ملف JSON';

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
  String get appVersion => 'Nayza Vocab v1.0.0\nتم الإنشاء لـ Nayzadorlar 🔱';

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
    return 'تم استيراد $count مجموعة بنجاح';
  }

  @override
  String importError(Object error) {
    return 'خطأ في الاستيراد: $error';
  }

  @override
  String get historyTitle => 'مجموعاتي';

  @override
  String get searchHint => 'ابحث عن مجموعة أو كلمة...';

  @override
  String get noResults => 'لم يتم العثور على نتائج';

  @override
  String get noCollections => 'لا توجد مجموعات حتى الآن';

  @override
  String get collectionsLabel => 'المجموعات';

  @override
  String get foundWordsLabel => 'الكلمات الموجودة';

  @override
  String get editWord => 'تعديل الكلمة';

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
    return '$count كلمات';
  }

  @override
  String get selectCollectionsTitle => 'تحديد المجموعات';

  @override
  String get emptyCollectionsWarning =>
      'يجب عليك إنشاء مجموعة واحدة على الأقل أولاً.';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get deselectAll => 'إلغاء تحديد الكل';

  @override
  String get selectToStart => 'حدد للبدء';

  @override
  String get emptySelectionWarning => 'المجموعات المحددة فارغة!';

  @override
  String get quizSetupTitle => 'إعداد الاختبار';

  @override
  String get selectQuizMode => 'حدد وضع الاختبار';

  @override
  String get selectDirection => 'اتجاه الاختبار';

  @override
  String get start => 'ابدأ';

  @override
  String get choiceMode => 'اختيار من متعدد';

  @override
  String get choiceSubtitle => 'اختر من 4 خيارات';

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
  String get matchingSubtitle => 'ابحث عن الأزواج';

  @override
  String get originalToTranslation => 'الأصلي -> الترجمة';

  @override
  String get translationToOriginal => 'الترجمة -> الأصلي';

  @override
  String get randomDirection => 'مختلط (عشوائي)';

  @override
  String get originalToTranslationSubtitle => 'مثال: الإنجليزية -> الأوزبكية';

  @override
  String get translationToOriginalSubtitle => 'مثال: الأوزبكية -> الإنجليزية';

  @override
  String get randomDirectionSubtitle => 'تغيير عشوائي';

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
    return 'نتيجتك: $score';
  }

  @override
  String correctCountLabel(Object count) {
    return 'صحيح: $count';
  }

  @override
  String incorrectCountLabel(Object count) {
    return 'غير صحيح: $count';
  }

  @override
  String get finish => 'إنهاء';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String learnedWordsCount(Object count) {
    return 'لقد أتقنت $count كلمة في هذه الجلسة!';
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
  String get findPairsLabel => 'ابحث عن الأزواج';

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
  String get collectionNameHint => 'مثل: السفر، العائلة...';

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
  String get uzbekLang => 'الأوزبكية (بدون نطق)';

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
    return 'متوفر $count كلمات';
  }

  @override
  String get masteryExplanation => 'تعتبر الكلمة متقنة بعد إجابة واحدة صحيحة';

  @override
  String get progressLabel => 'التقدم';

  @override
  String get selectSetsTitle => 'تحديد المجموعات';

  @override
  String get selectAtLeastOneSet => 'يرجى تحديد مجموعة واحدة على الأقل.';

  @override
  String get exportSuccess => 'اكتمل التصدير بنجاح!';

  @override
  String get shareSuccess => 'تمت المشاركة بنجاح!';

  @override
  String shareSubject(Object title) {
    return 'NayzaVocab: $title';
  }

  @override
  String shareMessage(Object count, Object lang, Object title) {
    return '📚 مجموعة Nayza Vocab: $title\n🌐 اللغة: $lang\n📝 الكلمات: $count\n\nقم باستيراد هذا الملف إلى Nayza Vocab للتعلم معاً!';
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
  String get onboardingWelcome => 'مرحباً بكم في NAYZA VOCAB';

  @override
  String get onboardingPage1Title => 'أتقن مفرداتك';

  @override
  String get onboardingPage1Subtitle =>
      'أقوى طريقة لتعلم وتذكر الكلمات الجديدة بأساليب مدعومة علمياً.';

  @override
  String get onboardingPage2Title => 'بطاقات تعليمية وألعاب';

  @override
  String get onboardingPage2Subtitle =>
      'اختبارات تفاعلية وألعاب مطابقة مصممة لجعل التعلم إدماناً.';

  @override
  String get onboardingPage3Title => 'تتبع تقدمك';

  @override
  String get onboardingPage3Subtitle =>
      'شاهد تحسنك بمرور الوقت وركز على الكلمات الصعبة.';

  @override
  String get onboardingGetStarted => 'البدء';
}
