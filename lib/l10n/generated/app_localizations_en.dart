// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nayza Vocab';

  @override
  String get homeTitle => 'CHECK YOUR KNOWLEDGE!';

  @override
  String get homeSubtitle => 'Choose your collections and start the test.';

  @override
  String get startTest => 'START TEST';

  @override
  String get matchingGame => 'MATCHING GAME';

  @override
  String get manageCollections => 'MANAGE COLLECTIONS';

  @override
  String get settings => 'Settings';

  @override
  String get history => 'Collections';

  @override
  String get collections => 'Collections';

  @override
  String get difficultWordsTitle => 'DIFFICULT WORDS';

  @override
  String difficultWordsSubtitle(int count) {
    return 'You have $count failed words';
  }

  @override
  String difficultSetTitle(int number) {
    return 'Difficult Words #$number';
  }

  @override
  String get removeFromDifficult => 'Remove from difficult words list';

  @override
  String get noDifficultWords => 'No difficult words yet. Keep practicing!';

  @override
  String get myCollectionsHeader => 'MY COLLECTIONS';

  @override
  String get difficultCollectionsHeader => 'DIFFICULT SETS';

  @override
  String get muteOn => 'Unmute';

  @override
  String get muteOff => 'Mute';

  @override
  String get dataManagement => 'DATA MANAGEMENT';

  @override
  String get export => 'Share or Backup';

  @override
  String get exportSubtitle => 'Select collections to share or create a backup';

  @override
  String get import => 'Add Words or Restore';

  @override
  String get importSubtitle => 'Load collections from a backup file (JSON)';

  @override
  String get notifications => 'NOTIFICATIONS';

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String reminderSubtitle(String time) {
    return 'Remind daily at $time';
  }

  @override
  String get reminderDefault => 'Remind difficult words daily';

  @override
  String reminderSetSuccess(Object time) {
    return 'Daily reminder set for $time';
  }

  @override
  String get appInfo => 'APP INFO';

  @override
  String get appVersion => 'Nayza Vocab v1.0.1\nCreated for Nayzadorlar 🔱';

  @override
  String get language => 'Language';

  @override
  String get uzbek => 'Uzbek';

  @override
  String get russian => 'Russian';

  @override
  String get english => 'English';

  @override
  String importSuccess(Object count) {
    return 'Successfully imported $count collections';
  }

  @override
  String importError(Object error) {
    return 'Import error: $error';
  }

  @override
  String get historyTitle => 'MY COLLECTIONS';

  @override
  String get searchHint => 'Search collection or word...';

  @override
  String get noResults => 'No results found';

  @override
  String get noCollections => 'No collections yet';

  @override
  String get collectionsLabel => 'COLLECTIONS';

  @override
  String get foundWordsLabel => 'FOUND WORDS';

  @override
  String get editWord => 'EDIT WORD';

  @override
  String get editSetTitle => 'RENAME COLLECTION';

  @override
  String get originalWord => 'Original word';

  @override
  String get translationWord => 'Translation';

  @override
  String get cancel => 'CANCEL';

  @override
  String get save => 'SAVE';

  @override
  String get wordUpdated => 'Word updated';

  @override
  String wordCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '1 word',
    );
    return '$_temp0';
  }

  @override
  String setsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String get selectCollectionsTitle => 'SELECT COLLECTIONS';

  @override
  String get emptyCollectionsWarning =>
      'You must create at least one collection first.';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get selectToStart => 'Select to start';

  @override
  String get emptySelectionWarning => 'Selected collections are empty!';

  @override
  String get quizSetupTitle => 'QUIZ SETUP';

  @override
  String get selectQuizMode => 'SELECT QUIZ MODE';

  @override
  String get selectDirection => 'QUIZ DIRECTION';

  @override
  String get start => 'START';

  @override
  String get choiceMode => 'Multiple Choice';

  @override
  String get choiceSubtitle => 'Select from 4 options';

  @override
  String get inputMode => 'Writing';

  @override
  String get inputSubtitle => 'Type the answer yourself';

  @override
  String get flashcardMode => 'Flashcard';

  @override
  String get flashcardSubtitle => 'Classic repetition';

  @override
  String get matchingMode => 'Matching';

  @override
  String get matchingSubtitle => 'Find the pairs';

  @override
  String get originalToTranslation => 'Original -> Translation';

  @override
  String get translationToOriginal => 'Translation -> Original';

  @override
  String get randomDirection => 'Mixed (Random)';

  @override
  String get originalToTranslationSubtitle => 'Example: English -> Uzbek';

  @override
  String get translationToOriginalSubtitle => 'Example: Uzbek -> English';

  @override
  String get randomDirectionSubtitle => 'Randomly alternate';

  @override
  String correctAnswerLabel(String answer) {
    return 'Correct answer: $answer';
  }

  @override
  String get typeTranslationHint => 'Type translation...';

  @override
  String get summaryTitle => 'QUIZ SUMMARY';

  @override
  String scoreLabel(int score) {
    return 'YOUR SCORE: $score';
  }

  @override
  String correctCountLabel(Object count) {
    return 'Correct: $count';
  }

  @override
  String incorrectCountLabel(Object count) {
    return 'Incorrect: $count';
  }

  @override
  String get finish => 'FINISH';

  @override
  String get tryAgain => 'TRY AGAIN';

  @override
  String learnedWordsCount(Object count) {
    return 'You\'ve mastered $count words in this session!';
  }

  @override
  String get flashcardLabel => 'FLASHCARD';

  @override
  String get knowWord => 'I KNOW';

  @override
  String get dontKnowWord => 'I DON\'T KNOW';

  @override
  String get matchingGameTitle => 'MATCHING GAME';

  @override
  String get findPairsLabel => 'FIND THE PAIRS';

  @override
  String stageLabel(int count) {
    return 'Stage $count';
  }

  @override
  String get gameOverTitle => 'GAME OVER!';

  @override
  String get createSetTitle => 'NEW COLLECTION';

  @override
  String get collectionNameLabel => 'Collection Name';

  @override
  String get collectionNameHint => 'e.g. Travel, Family...';

  @override
  String get nameRequiredError => 'Please enter a name';

  @override
  String get languageLabel => 'Learning Language';

  @override
  String get englishLang => 'English';

  @override
  String get arabicLang => 'Arabic';

  @override
  String get russianLang => 'Russian';

  @override
  String get uzbekLang => 'Uzbek';

  @override
  String get germanLang => 'German';

  @override
  String get koreanLang => 'Korean';

  @override
  String get wordPlaceholder => 'Word';

  @override
  String get translationPlaceholder => 'Translation';

  @override
  String get addRowButton => 'ADD ROW';

  @override
  String get atLeastOneWordWarning => 'Enter at least one word';

  @override
  String get setNotFound => 'Collection not found.';

  @override
  String get deleteSetTitle => 'DELETE COLLECTION';

  @override
  String deleteSetConfirmation(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get delete => 'DELETE';

  @override
  String get addWord => 'ADD WORD';

  @override
  String get emptySetWarning => 'This collection is empty.';

  @override
  String wordsFoundCount(int count) {
    return '$count words available';
  }

  @override
  String get masteryExplanation =>
      'A word is considered mastered after 1 correct answer';

  @override
  String get progressLabel => 'PROGRESS';

  @override
  String get selectSetsTitle => 'SELECT COLLECTIONS';

  @override
  String get selectAtLeastOneSet => 'Please select at least one collection.';

  @override
  String get exportSuccess => 'Export completed successfully!';

  @override
  String get shareSuccess => 'Set shared successfully!';

  @override
  String shareSubject(Object title) {
    return 'NayzaVocab: $title';
  }

  @override
  String shareMessage(Object count, Object lang, Object title) {
    return '📚 Nayza Vocab Set: $title\n🌐 Language: $lang\n📝 Words: $count\n\nImport this file into Nayza Vocab to learn together!';
  }

  @override
  String get importedSuffix => '(Imported)';

  @override
  String exportError(String error) {
    return 'Export error: $error';
  }

  @override
  String wordsCountLabel(int count) {
    return '$count words';
  }

  @override
  String exportAction(Object count) {
    return 'EXPORT ($count)';
  }

  @override
  String get onboardingWelcome => 'WELCOME TO NAYZA VOCAB';

  @override
  String get onboardingPage1Title => 'Master Your Vocabulary';

  @override
  String get onboardingPage1Subtitle =>
      'The most powerful way to learn and remember new words with science-backed methods.';

  @override
  String get onboardingPage2Title => 'Flashcards & Games';

  @override
  String get onboardingPage2Subtitle =>
      'Interactive quizzes and matching games designed to make learning addictive.';

  @override
  String get onboardingPage3Title => 'Track Your Progress';

  @override
  String get onboardingPage3Subtitle =>
      'See your improvements over time and focus on difficult words.';

  @override
  String get onboardingGetStarted => 'GET STARTED';

  @override
  String get skip => 'SKIP';

  @override
  String get submitAnswer => 'SUBMIT';

  @override
  String get collectionsPageTitle => 'COLLECTIONS';

  @override
  String get cancelReminder => 'Cancel Reminder';

  @override
  String get resetAllData => 'Reset All Data';

  @override
  String get resetAllDataConfirm =>
      'This will permanently delete all your sets and progress. Are you sure?';

  @override
  String get deleteSetConfirm => 'Do you want to delete this set?';

  @override
  String get communityAndUpdates => 'COMMUNITY & UPDATES';

  @override
  String get telegramChannel => 'Telegram Channel';

  @override
  String get telegramSubtitle => 'Join for tips, updates and resources';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get checkForUpdatesSubtitle => 'Get the latest version of Nayza Vocab';

  @override
  String get onboardingPage4Title => 'How it works?';

  @override
  String get onboardingPage4Subtitle =>
      'Master words through systematic repetition. Hard words come back more often until you know them by heart.';

  @override
  String get library => 'LIBRARY';

  @override
  String get createFolder => 'New Folder';

  @override
  String get folderName => 'Folder Name';

  @override
  String get create => 'CREATE';

  @override
  String get enterFolderName => 'Enter folder name';

  @override
  String get noFolder => 'Outside Folder (Main)';

  @override
  String get uncategorized => 'UNCATEGORIZED';

  @override
  String get dangerZone => 'DANGER ZONE';

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
  String get all => 'ALL';

  @override
  String get allDataCleared => 'All data cleared successfully!';

  @override
  String get share => 'Share';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get userName => 'User Name';

  @override
  String get userAge => 'Age';

  @override
  String get targetLanguage => 'Target Language';

  @override
  String get folderBreakdown => 'FOLDERS & LANGUAGES ANALYSIS';

  @override
  String get subjectBreakdown => 'COLLECTIONS BREAKDOWN';

  @override
  String yearsOld(int age) {
    return '$age years old';
  }

  @override
  String get masteredWords => 'Mastered';

  @override
  String get smartPasteTitle => 'Smart Paste';

  @override
  String get smartPasteHint =>
      'word - translation\nanother word = another translation';

  @override
  String get userNameHint => 'Your name';

  @override
  String get invalidAgeError => 'Please enter a valid age (1-120)';

  @override
  String get folders => 'Folders';

  @override
  String masteredPercentage(int percentage) {
    return '$percentage% mastered';
  }

  @override
  String get showLess => 'Show Less';

  @override
  String showAllWithCount(int count) {
    return 'View All ($count)';
  }

  @override
  String get rankNovice => '🛡️ Novice Warrior';

  @override
  String get rankAdvanced => '⚔️ Advanced Fighter';

  @override
  String get rankCommander => '🔱 Nayza Commander';

  @override
  String get rankWordMaster => '👑 Vocabulary Master';

  @override
  String get latestVersionInstalled => 'You have the latest version installed';

  @override
  String get updateAvailable => 'Update available';

  @override
  String get updateNow => 'Update now';

  @override
  String get downloadingUpdate => 'Downloading update...';

  @override
  String get updateCheckFailed => 'Failed to check for updates';

  @override
  String get whatsNew => 'What\'s new';

  @override
  String get openInBrowser => 'Download in browser';

  @override
  String get audioSpeed => 'Audio Speed';

  @override
  String get speedSlow => 'Slow (0.75x)';

  @override
  String get speedNormal => 'Normal (1.0x)';

  @override
  String get speedFast => 'Fast (1.25x)';
}
