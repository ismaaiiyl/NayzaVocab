import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('ko'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Nayza Vocab'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'CHECK YOUR KNOWLEDGE!'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your collections and start the test.'**
  String get homeSubtitle;

  /// No description provided for @startTest.
  ///
  /// In en, this message translates to:
  /// **'START TEST'**
  String get startTest;

  /// No description provided for @matchingGame.
  ///
  /// In en, this message translates to:
  /// **'MATCHING GAME'**
  String get matchingGame;

  /// No description provided for @manageCollections.
  ///
  /// In en, this message translates to:
  /// **'MANAGE COLLECTIONS'**
  String get manageCollections;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @collections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collections;

  /// No description provided for @difficultWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'DIFFICULT WORDS'**
  String get difficultWordsTitle;

  /// No description provided for @difficultWordsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You have {count} failed words'**
  String difficultWordsSubtitle(int count);

  /// No description provided for @difficultSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Difficult Words #{number}'**
  String difficultSetTitle(int number);

  /// No description provided for @removeFromDifficult.
  ///
  /// In en, this message translates to:
  /// **'Remove from difficult words list'**
  String get removeFromDifficult;

  /// No description provided for @noDifficultWords.
  ///
  /// In en, this message translates to:
  /// **'No difficult words yet. Keep practicing!'**
  String get noDifficultWords;

  /// No description provided for @myCollectionsHeader.
  ///
  /// In en, this message translates to:
  /// **'MY COLLECTIONS'**
  String get myCollectionsHeader;

  /// No description provided for @difficultCollectionsHeader.
  ///
  /// In en, this message translates to:
  /// **'DIFFICULT SETS'**
  String get difficultCollectionsHeader;

  /// No description provided for @muteOn.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get muteOn;

  /// No description provided for @muteOff.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get muteOff;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'DATA MANAGEMENT'**
  String get dataManagement;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export (Backup)'**
  String get export;

  /// No description provided for @exportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select and backup collections'**
  String get exportSubtitle;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import (Restore)'**
  String get import;

  /// No description provided for @importSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Load collections from JSON file'**
  String get importSubtitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notifications;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// No description provided for @reminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remind daily at {time}'**
  String reminderSubtitle(String time);

  /// No description provided for @reminderDefault.
  ///
  /// In en, this message translates to:
  /// **'Remind difficult words daily'**
  String get reminderDefault;

  /// No description provided for @reminderSetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder set for {time}'**
  String reminderSetSuccess(Object time);

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'APP INFO'**
  String get appInfo;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Nayza Vocab v1.0.0\nCreated for Nayzadorlar 🔱'**
  String get appVersion;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @uzbek.
  ///
  /// In en, this message translates to:
  /// **'Uzbek'**
  String get uzbek;

  /// No description provided for @russian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} collections'**
  String importSuccess(Object count);

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import error: {error}'**
  String importError(Object error);

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'MY COLLECTIONS'**
  String get historyTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search collection or word...'**
  String get searchHint;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @noCollections.
  ///
  /// In en, this message translates to:
  /// **'No collections yet'**
  String get noCollections;

  /// No description provided for @collectionsLabel.
  ///
  /// In en, this message translates to:
  /// **'COLLECTIONS'**
  String get collectionsLabel;

  /// No description provided for @foundWordsLabel.
  ///
  /// In en, this message translates to:
  /// **'FOUND WORDS'**
  String get foundWordsLabel;

  /// No description provided for @editWord.
  ///
  /// In en, this message translates to:
  /// **'EDIT WORD'**
  String get editWord;

  /// No description provided for @originalWord.
  ///
  /// In en, this message translates to:
  /// **'Original word'**
  String get originalWord;

  /// No description provided for @translationWord.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translationWord;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get save;

  /// No description provided for @wordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Word updated'**
  String get wordUpdated;

  /// No description provided for @wordCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String wordCountLabel(int count);

  /// No description provided for @selectCollectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'SELECT COLLECTIONS'**
  String get selectCollectionsTitle;

  /// No description provided for @emptyCollectionsWarning.
  ///
  /// In en, this message translates to:
  /// **'You must create at least one collection first.'**
  String get emptyCollectionsWarning;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @selectToStart.
  ///
  /// In en, this message translates to:
  /// **'Select to start'**
  String get selectToStart;

  /// No description provided for @emptySelectionWarning.
  ///
  /// In en, this message translates to:
  /// **'Selected collections are empty!'**
  String get emptySelectionWarning;

  /// No description provided for @quizSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'QUIZ SETUP'**
  String get quizSetupTitle;

  /// No description provided for @selectQuizMode.
  ///
  /// In en, this message translates to:
  /// **'SELECT QUIZ MODE'**
  String get selectQuizMode;

  /// No description provided for @selectDirection.
  ///
  /// In en, this message translates to:
  /// **'QUIZ DIRECTION'**
  String get selectDirection;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @choiceMode.
  ///
  /// In en, this message translates to:
  /// **'Multiple Choice'**
  String get choiceMode;

  /// No description provided for @choiceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select from 4 options'**
  String get choiceSubtitle;

  /// No description provided for @inputMode.
  ///
  /// In en, this message translates to:
  /// **'Writing'**
  String get inputMode;

  /// No description provided for @inputSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Type the answer yourself'**
  String get inputSubtitle;

  /// No description provided for @flashcardMode.
  ///
  /// In en, this message translates to:
  /// **'Flashcard'**
  String get flashcardMode;

  /// No description provided for @flashcardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Classic repetition'**
  String get flashcardSubtitle;

  /// No description provided for @matchingMode.
  ///
  /// In en, this message translates to:
  /// **'Matching'**
  String get matchingMode;

  /// No description provided for @matchingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the pairs'**
  String get matchingSubtitle;

  /// No description provided for @originalToTranslation.
  ///
  /// In en, this message translates to:
  /// **'Original -> Translation'**
  String get originalToTranslation;

  /// No description provided for @translationToOriginal.
  ///
  /// In en, this message translates to:
  /// **'Translation -> Original'**
  String get translationToOriginal;

  /// No description provided for @randomDirection.
  ///
  /// In en, this message translates to:
  /// **'Mixed (Random)'**
  String get randomDirection;

  /// No description provided for @originalToTranslationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Example: English -> Uzbek'**
  String get originalToTranslationSubtitle;

  /// No description provided for @translationToOriginalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Example: Uzbek -> English'**
  String get translationToOriginalSubtitle;

  /// No description provided for @randomDirectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Randomly alternate'**
  String get randomDirectionSubtitle;

  /// No description provided for @correctAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct answer: {answer}'**
  String correctAnswerLabel(String answer);

  /// No description provided for @typeTranslationHint.
  ///
  /// In en, this message translates to:
  /// **'Type translation...'**
  String get typeTranslationHint;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'QUIZ SUMMARY'**
  String get summaryTitle;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR SCORE: {score}'**
  String scoreLabel(int score);

  /// No description provided for @correctCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct: {count}'**
  String correctCountLabel(Object count);

  /// No description provided for @incorrectCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Incorrect: {count}'**
  String incorrectCountLabel(Object count);

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'FINISH'**
  String get finish;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'TRY AGAIN'**
  String get tryAgain;

  /// No description provided for @learnedWordsCount.
  ///
  /// In en, this message translates to:
  /// **'You\'ve mastered {count} words in this session!'**
  String learnedWordsCount(Object count);

  /// No description provided for @flashcardLabel.
  ///
  /// In en, this message translates to:
  /// **'FLASHCARD'**
  String get flashcardLabel;

  /// No description provided for @knowWord.
  ///
  /// In en, this message translates to:
  /// **'I KNOW'**
  String get knowWord;

  /// No description provided for @dontKnowWord.
  ///
  /// In en, this message translates to:
  /// **'I DON\'T KNOW'**
  String get dontKnowWord;

  /// No description provided for @matchingGameTitle.
  ///
  /// In en, this message translates to:
  /// **'MATCHING GAME'**
  String get matchingGameTitle;

  /// No description provided for @findPairsLabel.
  ///
  /// In en, this message translates to:
  /// **'FIND THE PAIRS'**
  String get findPairsLabel;

  /// No description provided for @stageLabel.
  ///
  /// In en, this message translates to:
  /// **'Stage {count}'**
  String stageLabel(int count);

  /// No description provided for @gameOverTitle.
  ///
  /// In en, this message translates to:
  /// **'GAME OVER!'**
  String get gameOverTitle;

  /// No description provided for @createSetTitle.
  ///
  /// In en, this message translates to:
  /// **'NEW COLLECTION'**
  String get createSetTitle;

  /// No description provided for @collectionNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Collection Name'**
  String get collectionNameLabel;

  /// No description provided for @collectionNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Travel, Family...'**
  String get collectionNameHint;

  /// No description provided for @nameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get nameRequiredError;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Learning Language'**
  String get languageLabel;

  /// No description provided for @englishLang.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLang;

  /// No description provided for @arabicLang.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLang;

  /// No description provided for @russianLang.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russianLang;

  /// No description provided for @uzbekLang.
  ///
  /// In en, this message translates to:
  /// **'Uzbek (TTS off)'**
  String get uzbekLang;

  /// No description provided for @germanLang.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get germanLang;

  /// No description provided for @koreanLang.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get koreanLang;

  /// No description provided for @wordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get wordPlaceholder;

  /// No description provided for @translationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translationPlaceholder;

  /// No description provided for @addRowButton.
  ///
  /// In en, this message translates to:
  /// **'ADD ROW'**
  String get addRowButton;

  /// No description provided for @atLeastOneWordWarning.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one word'**
  String get atLeastOneWordWarning;

  /// No description provided for @setNotFound.
  ///
  /// In en, this message translates to:
  /// **'Collection not found.'**
  String get setNotFound;

  /// No description provided for @deleteSetTitle.
  ///
  /// In en, this message translates to:
  /// **'DELETE COLLECTION'**
  String get deleteSetTitle;

  /// No description provided for @deleteSetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String deleteSetConfirmation(String title);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get delete;

  /// No description provided for @addWord.
  ///
  /// In en, this message translates to:
  /// **'ADD WORD'**
  String get addWord;

  /// No description provided for @emptySetWarning.
  ///
  /// In en, this message translates to:
  /// **'This collection is empty.'**
  String get emptySetWarning;

  /// No description provided for @wordsFoundCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words available'**
  String wordsFoundCount(int count);

  /// No description provided for @masteryExplanation.
  ///
  /// In en, this message translates to:
  /// **'A word is considered mastered after 1 correct answer'**
  String get masteryExplanation;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'PROGRESS'**
  String get progressLabel;

  /// No description provided for @selectSetsTitle.
  ///
  /// In en, this message translates to:
  /// **'SELECT COLLECTIONS'**
  String get selectSetsTitle;

  /// No description provided for @selectAtLeastOneSet.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one collection.'**
  String get selectAtLeastOneSet;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export completed successfully!'**
  String get exportSuccess;

  /// No description provided for @shareSuccess.
  ///
  /// In en, this message translates to:
  /// **'Set shared successfully!'**
  String get shareSuccess;

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'NayzaVocab: {title}'**
  String shareSubject(Object title);

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'📚 Nayza Vocab Set: {title}\n🌐 Language: {lang}\n📝 Words: {count}\n\nImport this file into Nayza Vocab to learn together!'**
  String shareMessage(Object count, Object lang, Object title);

  /// No description provided for @importedSuffix.
  ///
  /// In en, this message translates to:
  /// **'(Imported)'**
  String get importedSuffix;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Export error: {error}'**
  String exportError(String error);

  /// No description provided for @wordsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String wordsCountLabel(int count);

  /// No description provided for @exportAction.
  ///
  /// In en, this message translates to:
  /// **'EXPORT ({count})'**
  String exportAction(Object count);

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO NAYZA VOCAB'**
  String get onboardingWelcome;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Master Your Vocabulary'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'The most powerful way to learn and remember new words with science-backed methods.'**
  String get onboardingPage1Subtitle;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Flashcards & Games'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Interactive quizzes and matching games designed to make learning addictive.'**
  String get onboardingPage2Subtitle;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Track Your Progress'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'See your improvements over time and focus on difficult words.'**
  String get onboardingPage3Subtitle;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get onboardingGetStarted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'ko',
    'ru',
    'uz',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
