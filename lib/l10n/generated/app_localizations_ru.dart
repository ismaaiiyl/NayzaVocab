// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Nayza Vocab';

  @override
  String get homeTitle => 'ПРОВЕРЬ СВОИ ЗНАНИЯ!';

  @override
  String get homeSubtitle => 'Выберите свои коллекции и начните тест.';

  @override
  String get startTest => 'НАЧАТЬ ТЕСТ';

  @override
  String get matchingGame => 'ИГРА В ПАРЫ';

  @override
  String get manageCollections => 'УПРАВЛЕНИЕ КОЛЛЕКЦИЯМИ';

  @override
  String get settings => 'Настройки';

  @override
  String get history => 'История';

  @override
  String get collections => 'Коллекции';

  @override
  String get difficultWordsTitle => 'СЛОЖНЫЕ СЛОВА';

  @override
  String difficultWordsSubtitle(int count) {
    return 'У вас $count слов с ошибками';
  }

  @override
  String difficultSetTitle(int number) {
    return 'Сложные слова #$number';
  }

  @override
  String get removeFromDifficult => 'Удалить из списка сложных слов';

  @override
  String get noDifficultWords =>
      'Пока нет сложных слов. Продолжайте тренироваться!';

  @override
  String get myCollectionsHeader => 'МОИ КОЛЛЕКЦИИ';

  @override
  String get difficultCollectionsHeader => 'СЛОЖНЫЕ ПОДБОРКИ';

  @override
  String get muteOn => 'Включить звук';

  @override
  String get muteOff => 'Выключить звук';

  @override
  String get dataManagement => 'УПРАВЛЕНИЕ ДАННЫМИ';

  @override
  String get export => 'Поделиться или бэкап';

  @override
  String get exportSubtitle =>
      'Выберите коллекции для передачи или создания резервной копии';

  @override
  String get import => 'Добавить слова или восстановить';

  @override
  String get importSubtitle =>
      'Загрузить коллекции из файла резервной копии (JSON)';

  @override
  String get notifications => 'УВЕДОМЛЕНИЯ';

  @override
  String get dailyReminder => 'Ежедневное напоминание';

  @override
  String reminderSubtitle(String time) {
    return 'Напоминать ежедневно в $time';
  }

  @override
  String get reminderDefault => 'Напоминать сложные слова ежедневно';

  @override
  String reminderSetSuccess(Object time) {
    return 'Напоминание установлено на $time';
  }

  @override
  String get appInfo => 'О ПРИЛОЖЕНИИ';

  @override
  String get appVersion => 'Nayza Vocab v1.0.0\nCreated for Nayzadorlar 🔱';

  @override
  String get language => 'Язык';

  @override
  String get uzbek => 'Узбекский';

  @override
  String get russian => 'Русский';

  @override
  String get english => 'Английский';

  @override
  String importSuccess(Object count) {
    return 'Успешно импортировано $count коллекций';
  }

  @override
  String importError(Object error) {
    return 'Ошибка импорта: $error';
  }

  @override
  String get historyTitle => 'МОИ КОЛЛЕКЦИИ';

  @override
  String get searchHint => 'Поиск коллекции или слова...';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get noCollections => 'Нет коллекций';

  @override
  String get collectionsLabel => 'КОЛЛЕКЦИИ';

  @override
  String get foundWordsLabel => 'НАЙДЕННЫЕ СЛОВА';

  @override
  String get editWord => 'ИЗМЕНИТЬ СЛОВО';

  @override
  String get editSetTitle => 'ПЕРЕИМЕНОВАТЬ КОЛЛЕКЦИЮ';

  @override
  String get originalWord => 'Оригинал';

  @override
  String get translationWord => 'Перевод';

  @override
  String get cancel => 'ОТМЕНА';

  @override
  String get save => 'СОХРАНИТЬ';

  @override
  String get wordUpdated => 'Слово обновлено';

  @override
  String wordCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count слов',
      few: '$count слова',
      one: '$count слово',
    );
    return '$_temp0';
  }

  @override
  String setsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count наборов',
      few: '$count набора',
      one: '$count набор',
    );
    return '$_temp0';
  }

  @override
  String get selectCollectionsTitle => 'ВЫБОР КОЛЛЕКЦИЙ';

  @override
  String get emptyCollectionsWarning =>
      'Сначала создайте хотя бы одну коллекцию.';

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get deselectAll => 'Снять выделение';

  @override
  String get selectToStart => 'Выберите для начала';

  @override
  String get emptySelectionWarning => 'Выбранные коллекции пусты!';

  @override
  String get quizSetupTitle => 'НАСТРОЙКИ ТЕСТА';

  @override
  String get selectQuizMode => 'ВЫБЕРИТЕ ТИП ТЕСТА';

  @override
  String get selectDirection => 'НАПРАВЛЕНИЕ ТЕСТА';

  @override
  String get start => 'НАЧАТЬ';

  @override
  String get choiceMode => 'Выбор варианта';

  @override
  String get choiceSubtitle => 'Выбор из 4 вариантов';

  @override
  String get inputMode => 'Письменно';

  @override
  String get inputSubtitle => 'Вводите ответ сами';

  @override
  String get flashcardMode => 'Флэш-карты';

  @override
  String get flashcardSubtitle => 'Классическое повторение';

  @override
  String get matchingMode => 'Сопоставление';

  @override
  String get matchingSubtitle => 'Найдите пары слов';

  @override
  String get originalToTranslation => 'Оригинал -> Перевод';

  @override
  String get translationToOriginal => 'Перевод -> Оригинал';

  @override
  String get randomDirection => 'Смешанный (Рандом)';

  @override
  String get originalToTranslationSubtitle =>
      'Например: Английский -> Узбекский';

  @override
  String get translationToOriginalSubtitle =>
      'Например: Узбекский -> Английский';

  @override
  String get randomDirectionSubtitle => 'В случайном порядке';

  @override
  String correctAnswerLabel(String answer) {
    return 'Правильный ответ: $answer';
  }

  @override
  String get typeTranslationHint => 'Введите перевод...';

  @override
  String get summaryTitle => 'РЕЗУЛЬТАТЫ';

  @override
  String scoreLabel(int score) {
    return 'ВАШ СЧЕТ: $score';
  }

  @override
  String correctCountLabel(Object count) {
    return 'Верно: $count';
  }

  @override
  String incorrectCountLabel(Object count) {
    return 'Неверно: $count';
  }

  @override
  String get finish => 'ЗАВЕРШИТЬ';

  @override
  String get tryAgain => 'ПОВТОРИТЬ';

  @override
  String learnedWordsCount(Object count) {
    return 'Вы выучили $count слов в этой сессии!';
  }

  @override
  String get flashcardLabel => 'ФЛЭШ-КАРТА';

  @override
  String get knowWord => 'ЗНАЮ';

  @override
  String get dontKnowWord => 'НЕ ЗНАЮ';

  @override
  String get matchingGameTitle => 'ИГРА В ПАРЫ';

  @override
  String get findPairsLabel => 'НАЙДИТЕ ПАРЫ';

  @override
  String stageLabel(int count) {
    return 'Этап $count';
  }

  @override
  String get gameOverTitle => 'ИГРА ЗАКОНЧЕНА!';

  @override
  String get createSetTitle => 'НОВАЯ КОЛЛЕКЦИЯ';

  @override
  String get collectionNameLabel => 'Название коллекции';

  @override
  String get collectionNameHint => 'Напр: Путешествия, Семья...';

  @override
  String get nameRequiredError => 'Введите название';

  @override
  String get languageLabel => 'Изучаемый язык';

  @override
  String get englishLang => 'Английский';

  @override
  String get arabicLang => 'Арабский';

  @override
  String get russianLang => 'Русский';

  @override
  String get uzbekLang => 'Узбекский';

  @override
  String get germanLang => 'Немецкий';

  @override
  String get koreanLang => 'Корейский';

  @override
  String get wordPlaceholder => 'Слово';

  @override
  String get translationPlaceholder => 'Перевод';

  @override
  String get addRowButton => 'ДОБАВИТЬ СТРОКУ';

  @override
  String get atLeastOneWordWarning => 'Введите хотя бы одно слово';

  @override
  String get setNotFound => 'Коллекция не найдена.';

  @override
  String get deleteSetTitle => 'УДАЛИТЬ КОЛЛЕКЦИЮ';

  @override
  String deleteSetConfirmation(String title) {
    return 'Вы уверены, что хотите удалить \"$title\"?';
  }

  @override
  String get delete => 'УДАЛИТЬ';

  @override
  String get addWord => 'ДОБАВИТЬ СЛОВО';

  @override
  String get emptySetWarning => 'Эта коллекция пуста.';

  @override
  String wordsFoundCount(int count) {
    return 'Доступно слов: $count';
  }

  @override
  String get masteryExplanation =>
      'Слово считается выученным после 1 правильного ответа';

  @override
  String get progressLabel => 'ПРОГРЕСС';

  @override
  String get selectSetsTitle => 'ВЫБОР КОЛЛЕКЦИЙ';

  @override
  String get selectAtLeastOneSet => 'Выберите хотя бы одну коллекцию.';

  @override
  String get exportSuccess => 'Экспорт успешно завершен!';

  @override
  String get shareSuccess => 'Успешно отправлено!';

  @override
  String shareSubject(Object title) {
    return 'NayzaVocab: $title';
  }

  @override
  String shareMessage(Object count, Object lang, Object title) {
    return '📚 Коллекция Nayza Vocab: $title\n🌐 Язык: $lang\n📝 Слов: $count\n\nИмпортируйте этот файл в Nayza Vocab, чтобы учиться вместе!';
  }

  @override
  String get importedSuffix => '(Импортировано)';

  @override
  String exportError(String error) {
    return 'Ошибка экспорта: $error';
  }

  @override
  String wordsCountLabel(int count) {
    return 'Слов: $count';
  }

  @override
  String exportAction(Object count) {
    return 'ЭКСПОРТИРОВАТЬ ($count)';
  }

  @override
  String get onboardingWelcome => 'ДОБРО ПОЖАЛОВАТЬ В NAYZA VOCAB';

  @override
  String get onboardingPage1Title => 'Совершенствуйте Свой Словарный Запас';

  @override
  String get onboardingPage1Subtitle =>
      'Самый мощный способ изучения и запоминания новых слов с использованием научно обоснованных методов.';

  @override
  String get onboardingPage2Title => 'Флэш-карты и Игры';

  @override
  String get onboardingPage2Subtitle =>
      'Интерактивные тесты и игры в пары, разработанные для того, чтобы сделать обучение увлекательным.';

  @override
  String get onboardingPage3Title => 'Отслеживайте Свой Прогресс';

  @override
  String get onboardingPage3Subtitle =>
      'Следите за своим ростом с течением времени и сосредоточьтесь на трудных словах.';

  @override
  String get onboardingGetStarted => 'НАЧАТЬ';

  @override
  String get skip => 'ПРОПУСТИТЬ';

  @override
  String get submitAnswer => 'ПОДТВЕРДИТЬ';

  @override
  String get collectionsPageTitle => 'КОЛЛЕКЦИИ';

  @override
  String get cancelReminder => 'Отменить напоминание';

  @override
  String get resetAllData => 'Сбросить все данные';

  @override
  String get resetAllDataConfirm =>
      'Это навсегда удалит все ваши коллекции и прогресс. Вы уверены?';

  @override
  String get deleteSetConfirm =>
      'Вы уверены, что хотите удалить эту коллекцию?';

  @override
  String get communityAndUpdates => 'СООБЩЕСТВО И ОБНОВЛЕНИЯ';

  @override
  String get telegramChannel => 'Telegram канал';

  @override
  String get telegramSubtitle => 'Присоединяйтесь для советов и новостей';

  @override
  String get checkForUpdates => 'Проверить обновления';

  @override
  String get checkForUpdatesSubtitle => 'Получите последнюю версию Nayza Vocab';

  @override
  String get onboardingPage4Title => 'Как это работает?';

  @override
  String get onboardingPage4Subtitle =>
      'Осваивайте слова через систему повторений. Сложные слова возвращаются чаще, пока вы их не запомните.';

  @override
  String get library => 'БИБЛИОТЕКА';

  @override
  String get createFolder => 'Новая папка';

  @override
  String get folderName => 'Название папки';

  @override
  String get create => 'СОЗДАТЬ';

  @override
  String get enterFolderName => 'Введите название папки';

  @override
  String get noFolder => 'Вне папки (Главная)';

  @override
  String get uncategorized => 'БЕЗ КАТЕГОРИИ';

  @override
  String get dangerZone => 'ОПАСНАЯ ЗОНА';

  @override
  String shareError(Object error) {
    return 'Error sharing: $error';
  }

  @override
  String get rename => 'Rename';

  @override
  String get onlineLibraryTitle => 'NAYZA CLOUD LIBRARY';

  @override
  String get allTopics => 'ALL TOPICS';

  @override
  String wordCountLabel_short(Object count) {
    return '$count words';
  }

  @override
  String get downloadAll => 'DOWNLOAD ALL';

  @override
  String get installed => 'INSTALLED';

  @override
  String get downloading => 'Downloading...';

  @override
  String get deleteFolderConfirm =>
      'Deleting this folder will also delete all its sets and words. Are you sure?';

  @override
  String get connectionError => 'CONNECTION ERROR';

  @override
  String get noInternetMessage =>
      'Please check your internet connection and try again.';

  @override
  String get noResultsFound => 'NO RESULTS FOUND';

  @override
  String get clearFilters => 'CLEAR FILTERS';

  @override
  String get all => 'ВСЕ';

  @override
  String get allDataCleared => 'Все данные успешно удалены!';

  @override
  String get share => 'Поделиться';

  @override
  String get home => 'Главная';

  @override
  String get profile => 'Профиль';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get userName => 'Имя пользователя';

  @override
  String get userAge => 'Возраст';

  @override
  String get targetLanguage => 'Изучаемый язык';

  @override
  String get folderBreakdown => 'АНАЛИЗ ПАПОК И ЯЗЫКОВ';

  @override
  String get subjectBreakdown => 'ОБЗОР КОЛЛЕКЦИЙ';

  @override
  String yearsOld(int age) {
    return '$age лет';
  }

  @override
  String get masteredWords => 'Освоено';

  @override
  String get smartPasteTitle => 'Умная вставка';

  @override
  String get smartPasteHint => 'слово - перевод\nдругое слово = другой перевод';

  @override
  String get userNameHint => 'Ваше имя';

  @override
  String get invalidAgeError => 'Введите корректный возраст (1-120)';

  @override
  String get folders => 'Папки';

  @override
  String masteredPercentage(int percentage) {
    return '$percentage% освоено';
  }

  @override
  String get showLess => 'Свернуть';

  @override
  String showAllWithCount(int count) {
    return 'Все ($count)';
  }

  @override
  String get rankNovice => '🛡️ Начинающий Воин';

  @override
  String get rankAdvanced => '⚔️ Опытный Боец';

  @override
  String get rankCommander => '🔱 Командир Найза';

  @override
  String get rankWordMaster => '👑 Мастер Слов';

  @override
  String get latestVersionInstalled => 'У вас установлена последняя версия';

  @override
  String get updateAvailable => 'Доступно обновление';

  @override
  String get updateNow => 'Обновить сейчас';

  @override
  String get downloadingUpdate => 'Загрузка обновления...';

  @override
  String get updateCheckFailed => 'Не удалось проверить обновления';

  @override
  String get whatsNew => 'Что нового';

  @override
  String get openInBrowser => 'Скачать в браузере';

  @override
  String get audioSpeed => 'Скорость озвучки';

  @override
  String get speedSlow => 'Медленно (0.75x)';

  @override
  String get speedNormal => 'Обычная (1.0x)';

  @override
  String get speedFast => 'Быстро (1.25x)';
}
