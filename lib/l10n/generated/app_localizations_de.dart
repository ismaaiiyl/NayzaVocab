// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Nayza Vocab';

  @override
  String get homeTitle => 'ÜBERPRÜFE DEIN WISSEN!';

  @override
  String get homeSubtitle => 'Wähle deine Sammlungen und starte den Test.';

  @override
  String get startTest => 'TEST STARTEN';

  @override
  String get matchingGame => 'ZUORDNUNGSSPIEL';

  @override
  String get manageCollections => 'SAMMLUNGEN VERWALTEN';

  @override
  String get settings => 'Einstellungen';

  @override
  String get history => 'Verlauf';

  @override
  String get collections => 'Sammlungen';

  @override
  String get difficultWordsTitle => 'SCHWIERIGE WÖRTER';

  @override
  String difficultWordsSubtitle(int count) {
    return 'Du hast $count schwierige Wörter';
  }

  @override
  String difficultSetTitle(int number) {
    return 'Schwierige Wörter #$number';
  }

  @override
  String get removeFromDifficult =>
      'Aus der Liste schwieriger Wörter entfernen';

  @override
  String get noDifficultWords => 'Noch keine schwierigen Wörter. Übe weiter!';

  @override
  String get myCollectionsHeader => 'MEINE SAMMLUNGEN';

  @override
  String get difficultCollectionsHeader => 'SCHWIERIGE SAMMLUNGEN';

  @override
  String get muteOn => 'Stummschaltung aufheben';

  @override
  String get muteOff => 'Stummschalten';

  @override
  String get dataManagement => 'DATENVERWALTUNG';

  @override
  String get export => 'Teilen oder Backup';

  @override
  String get exportSubtitle => 'Sammlungen zum Teilen oder Sichern auswählen';

  @override
  String get import => 'Wörter hinzufügen oder wiederherstellen';

  @override
  String get importSubtitle => 'Sammlungen aus einer Backup-Datei (JSON) laden';

  @override
  String get notifications => 'BENACHRICHTIGUNGEN';

  @override
  String get dailyReminder => 'Tägliche Erinnerung';

  @override
  String reminderSubtitle(String time) {
    return 'Täglich um $time erinnern';
  }

  @override
  String get reminderDefault => 'Täglich an schwierige Wörter erinnern';

  @override
  String reminderSetSuccess(Object time) {
    return 'Tägliche Erinnerung for $time eingestellt';
  }

  @override
  String get appInfo => 'APP INFO';

  @override
  String get appVersion => 'Nayza Vocab v1.0.0\nErstellt für Nayzadorlar 🔱';

  @override
  String get language => 'Sprache';

  @override
  String get uzbek => 'Usbekisch';

  @override
  String get russian => 'Russisch';

  @override
  String get english => 'Englisch';

  @override
  String importSuccess(Object count) {
    return 'Erfolgreich $count Sammlungen importiert';
  }

  @override
  String importError(Object error) {
    return 'Importfehler: $error';
  }

  @override
  String get historyTitle => 'MEINE SAMMLUNGEN';

  @override
  String get searchHint => 'Sammlung oder Wort suchen...';

  @override
  String get noResults => 'Keine Ergebnisse gefunden';

  @override
  String get noCollections => 'Noch keine Sammlungen';

  @override
  String get collectionsLabel => 'SAMMLUNGEN';

  @override
  String get foundWordsLabel => 'GEFUNDENE WÖRTER';

  @override
  String get editWord => 'WORT BEARBEITEN';

  @override
  String get editSetTitle => 'SAMMLUNG UMBENENNEN';

  @override
  String get originalWord => 'Originalwort';

  @override
  String get translationWord => 'Übersetzung';

  @override
  String get cancel => 'ABBRECHEN';

  @override
  String get save => 'SPEICHERN';

  @override
  String get wordUpdated => 'Wort aktualisiert';

  @override
  String wordCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wörter',
      one: '1 Wort',
    );
    return '$_temp0';
  }

  @override
  String setsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sets',
      one: '1 Set',
    );
    return '$_temp0';
  }

  @override
  String get selectCollectionsTitle => 'SAMMLUNGEN AUSWÄHLEN';

  @override
  String get emptyCollectionsWarning =>
      'Du musst zuerst mindestens eine Sammlung erstellen.';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get deselectAll => 'Auswahl aufheben';

  @override
  String get selectToStart => 'Zum Starten auswählen';

  @override
  String get emptySelectionWarning => 'Ausgewählte Sammlungen sind leer!';

  @override
  String get quizSetupTitle => 'QUIZ SETUP';

  @override
  String get selectQuizMode => 'QUIZ-MODUS AUSWÄHLEN';

  @override
  String get selectDirection => 'QUIZ-RICHTUNG';

  @override
  String get start => 'START';

  @override
  String get choiceMode => 'Multiple Choice';

  @override
  String get choiceSubtitle => 'Wähle aus 4 Optionen';

  @override
  String get inputMode => 'Schreiben';

  @override
  String get inputSubtitle => 'Tippe die Antwort selbst ein';

  @override
  String get flashcardMode => 'Lernkarte';

  @override
  String get flashcardSubtitle => 'Klassische Wiederholung';

  @override
  String get matchingMode => 'Zuordnung';

  @override
  String get matchingSubtitle => 'Finde die Paare';

  @override
  String get originalToTranslation => 'Original -> Übersetzung';

  @override
  String get translationToOriginal => 'Übersetzung -> Original';

  @override
  String get randomDirection => 'Gemischt (Zufall)';

  @override
  String get originalToTranslationSubtitle => 'Beispiel: Englisch -> Usbekisch';

  @override
  String get translationToOriginalSubtitle => 'Beispiel: Usbekisch -> Englisch';

  @override
  String get randomDirectionSubtitle => 'Zufällig abwechseln';

  @override
  String correctAnswerLabel(String answer) {
    return 'Richtige Antwort: $answer';
  }

  @override
  String get typeTranslationHint => 'Übersetzung eingeben...';

  @override
  String get summaryTitle => 'QUIZ-ZUSAMMENFASSUNG';

  @override
  String scoreLabel(int score) {
    return 'DEIN ERGEBNIS: $score';
  }

  @override
  String correctCountLabel(Object count) {
    return 'Richtig: $count';
  }

  @override
  String incorrectCountLabel(Object count) {
    return 'Falsch: $count';
  }

  @override
  String get finish => 'BEENDEN';

  @override
  String get tryAgain => 'ERNEUT VERSUCHEN';

  @override
  String learnedWordsCount(Object count) {
    return 'Du hast $count Wörter in dieser Sitzung gemeistert!';
  }

  @override
  String get flashcardLabel => 'LERNKARTE';

  @override
  String get knowWord => 'ICH WEISS ES';

  @override
  String get dontKnowWord => 'ICH WEISS ES NICHT';

  @override
  String get matchingGameTitle => 'ZUORDNUNGSSPIEL';

  @override
  String get findPairsLabel => 'FINDE DIE PAARE';

  @override
  String stageLabel(int count) {
    return 'Stufe $count';
  }

  @override
  String get gameOverTitle => 'SPIEL VORBEI!';

  @override
  String get createSetTitle => 'NEUE SAMMLUNG';

  @override
  String get collectionNameLabel => 'Name der Sammlung';

  @override
  String get collectionNameHint => 'z.B. Reisen, Familie...';

  @override
  String get nameRequiredError => 'Bitte einen Namen eingeben';

  @override
  String get languageLabel => 'Lernsprache';

  @override
  String get englishLang => 'Englisch';

  @override
  String get arabicLang => 'Arabisch';

  @override
  String get russianLang => 'Russisch';

  @override
  String get uzbekLang => 'Usbekisch';

  @override
  String get germanLang => 'Deutsch';

  @override
  String get koreanLang => 'Koreanisch';

  @override
  String get wordPlaceholder => 'Wort';

  @override
  String get translationPlaceholder => 'Übersetzung';

  @override
  String get addRowButton => 'ZEILE HINZUFÜGEN';

  @override
  String get atLeastOneWordWarning => 'Gib mindestens ein Wort ein';

  @override
  String get setNotFound => 'Sammlung nicht gefunden.';

  @override
  String get deleteSetTitle => 'SAMMLUNG LÖSCHEN';

  @override
  String deleteSetConfirmation(String title) {
    return 'Bist du sicher, dass du \"$title\" löschen möchtest?';
  }

  @override
  String get delete => 'LÖSCHEN';

  @override
  String get addWord => 'WORT HINZUFÜGEN';

  @override
  String get emptySetWarning => 'Diese Sammlung ist leer.';

  @override
  String wordsFoundCount(int count) {
    return '$count Wörter verfügbar';
  }

  @override
  String get masteryExplanation =>
      'Ein Wort gilt nach 1 richtigen Antwort als gemeistert';

  @override
  String get progressLabel => 'FORTSCHRITT';

  @override
  String get selectSetsTitle => 'SAMMLUNGEN AUSWÄHLEN';

  @override
  String get selectAtLeastOneSet => 'Bitte wähle mindestens eine Sammlung aus.';

  @override
  String get exportSuccess => 'Export erfolgreich abgeschlossen!';

  @override
  String get shareSuccess => 'Erfolgreich geteilt!';

  @override
  String shareSubject(Object title) {
    return 'NayzaVocab: $title';
  }

  @override
  String shareMessage(Object count, Object lang, Object title) {
    return '📚 Nayza Vocab Sammlung: $title\n🌐 Sprache: $lang\n📝 Wörter: $count\n\nImportiere diese Datei in Nayza Vocab, um gemeinsam zu lernen!';
  }

  @override
  String get importedSuffix => '(Importiert)';

  @override
  String exportError(String error) {
    return 'Exportfehler: $error';
  }

  @override
  String wordsCountLabel(int count) {
    return '$count Wörter';
  }

  @override
  String exportAction(Object count) {
    return 'EXPORTIEREN ($count)';
  }

  @override
  String get onboardingWelcome => 'WILLKOMMEN BEI NAYZA VOCAB';

  @override
  String get onboardingPage1Title => 'Meistere deinen Wortschatz';

  @override
  String get onboardingPage1Subtitle =>
      'Der effektivste Weg, neue Wörter mit wissenschaftlich fundierten Methoden zu lernen.';

  @override
  String get onboardingPage2Title => 'Lernkarten & Spiele';

  @override
  String get onboardingPage2Subtitle =>
      'Interaktive Quizze und Zuordnungsspiele, die das Lernen süchtig machen.';

  @override
  String get onboardingPage3Title => 'Verfolge deinen Fortschritt';

  @override
  String get onboardingPage3Subtitle =>
      'Sieh dir deine Verbesserungen im Laufe der Zeit an und konzentriere dich auf schwierige Wörter.';

  @override
  String get onboardingGetStarted => 'LOSLEGEN';

  @override
  String get skip => 'ÜBERSPRINGEN';

  @override
  String get submitAnswer => 'BESTÄTIGEN';

  @override
  String get collectionsPageTitle => 'SAMMLUNGEN';

  @override
  String get cancelReminder => 'Erinnerung abbrechen';

  @override
  String get resetAllData => 'Alle Daten zurücksetzen';

  @override
  String get resetAllDataConfirm =>
      'Dadurch werden alle deine Sammlungen und Fortschritte dauerhaft gelöscht. Bist du sicher?';

  @override
  String get deleteSetConfirm =>
      'Sind Sie sicher, dass Sie diese Sammlung löschen möchten?';

  @override
  String get communityAndUpdates => 'COMMUNITY & UPDATES';

  @override
  String get telegramChannel => 'Telegram Kanal';

  @override
  String get telegramSubtitle => 'Tritt bei für Tipps und Updates';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get checkForUpdatesSubtitle =>
      'Hol dir die neueste Version von Nayza Vocab';

  @override
  String get onboardingPage4Title => 'Wie funktioniert es?';

  @override
  String get onboardingPage4Subtitle =>
      'Meistere Wörter durch systematische Wiederholung. Schwierige Wörter kommen öfter vor, bis du sie auswendig kennst.';

  @override
  String get library => 'BIBLIOTHEK';

  @override
  String get createFolder => 'Neuer Ordner';

  @override
  String get folderName => 'Ordnername';

  @override
  String get create => 'ERSTELLEN';

  @override
  String get enterFolderName => 'Ordnernamen eingeben';

  @override
  String get noFolder => 'Außerhalb des Ordners (Haupt)';

  @override
  String get uncategorized => 'NICHT KATEGORISIERT';

  @override
  String get dangerZone => 'GEFAHRENZONE';

  @override
  String shareError(Object error) {
    return 'Fehler beim Teilen: $error';
  }

  @override
  String get rename => 'Umbenennen';

  @override
  String get onlineLibraryTitle => 'NAYZA CLOUD BIBLIOTHEK';

  @override
  String get allTopics => 'ALLE THEMEN';

  @override
  String wordCountLabel_short(Object count) {
    return '$count Wörter';
  }

  @override
  String get downloadAll => 'ALLES HERUNTERLADEN';

  @override
  String get installed => 'INSTALLIERT';

  @override
  String get downloading => 'Laden...';

  @override
  String get deleteFolderConfirm =>
      'Das Löschen dieses Ordners löscht auch alle darin enthaltenen Sets und Wörter. Sind Sie sicher?';

  @override
  String get connectionError => 'VERBINDUNGSFEHLER';

  @override
  String get noInternetMessage =>
      'Bitte überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get noResultsFound => 'KEINE ERGEBNISSE GEFUNDEN';

  @override
  String get clearFilters => 'FILTER LÖSCHEN';

  @override
  String get all => 'ALLE';

  @override
  String get allDataCleared => 'Alle Daten wurden erfolgreich gelöscht!';

  @override
  String get share => 'Teilen';

  @override
  String get home => 'Start';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get userName => 'Benutzername';

  @override
  String get userAge => 'Alter';

  @override
  String get targetLanguage => 'Zielsprache';

  @override
  String get folderBreakdown => 'ORDNER- & SPRACHENANALYSE';

  @override
  String get subjectBreakdown => 'SAMMLUNGSÜBERSICHT';

  @override
  String yearsOld(int age) {
    return '$age Jahre alt';
  }

  @override
  String get masteredWords => 'Gemeistert';

  @override
  String get smartPasteTitle => 'Intelligentes Einfügen';

  @override
  String get smartPasteHint =>
      'Wort - Übersetzung\nanderes Wort = andere Übersetzung';

  @override
  String get userNameHint => 'Ihr Name';

  @override
  String get invalidAgeError => 'Bitte gültiges Alter eingeben (1-120)';

  @override
  String get folders => 'Ordner';

  @override
  String masteredPercentage(int percentage) {
    return '$percentage% gemeistert';
  }

  @override
  String get showLess => 'Weniger anzeigen';

  @override
  String showAllWithCount(int count) {
    return 'Alle ($count)';
  }

  @override
  String get rankNovice => '🛡️ Anfängerkrieger';

  @override
  String get rankAdvanced => '⚔️ Fortgeschrittener Kämpfer';

  @override
  String get rankCommander => '🔱 Nayza Kommandant';

  @override
  String get rankWordMaster => '👑 Meister der Wörter';

  @override
  String get latestVersionInstalled => 'Die neueste Version ist installiert';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get updateNow => 'Jetzt aktualisieren';

  @override
  String get downloadingUpdate => 'Update wird heruntergeladen...';

  @override
  String get updateCheckFailed => 'Update-Prüfung fehlgeschlagen';

  @override
  String get whatsNew => 'Was ist neu';

  @override
  String get openInBrowser => 'Im Browser herunterladen';

  @override
  String get audioSpeed => 'Audiogeschwindigkeit';

  @override
  String get speedSlow => 'Langsam (0.75x)';

  @override
  String get speedNormal => 'Normal (1.0x)';

  @override
  String get speedFast => 'Schnell (1.25x)';
}
