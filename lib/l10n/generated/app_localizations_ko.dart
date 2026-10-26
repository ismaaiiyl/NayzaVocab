// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Nayza Vocab';

  @override
  String get homeTitle => '당신의 지식을 확인하세요!';

  @override
  String get homeSubtitle => '컬렉션을 선택하고 테스트를 시작하세요.';

  @override
  String get startTest => '테스트 시작';

  @override
  String get matchingGame => '매칭 게임';

  @override
  String get manageCollections => '컬렉션 관리';

  @override
  String get settings => '설정';

  @override
  String get history => '기록';

  @override
  String get collections => '컬렉션';

  @override
  String get difficultWordsTitle => '어려운 단어';

  @override
  String difficultWordsSubtitle(int count) {
    return '$count개의 어려운 단어가 있습니다';
  }

  @override
  String difficultSetTitle(int number) {
    return '어려운 단어 #$number';
  }

  @override
  String get removeFromDifficult => '어려운 단어 목록에서 제거';

  @override
  String get noDifficultWords => '어려운 단어가 없습니다. 계속 연습하세요!';

  @override
  String get myCollectionsHeader => '내 컬렉션';

  @override
  String get difficultCollectionsHeader => '어려운 세트';

  @override
  String get muteOn => '음소거 해제';

  @override
  String get muteOff => '음소거';

  @override
  String get dataManagement => '데이터 관리';

  @override
  String get export => '공유 또는 백업';

  @override
  String get exportSubtitle => '공유 또는 백업할 컬렉션 선택';

  @override
  String get import => '단어 추가 또는 복원';

  @override
  String get importSubtitle => '백업 파일(JSON)에서 컬렉션 로드';

  @override
  String get notifications => '알림';

  @override
  String get dailyReminder => '일일 알림';

  @override
  String reminderSubtitle(String time) {
    return '매일 $time에 알림';
  }

  @override
  String get reminderDefault => '매일 어려운 단어 알림';

  @override
  String reminderSetSuccess(Object time) {
    return '$time에 일일 알림이 설정되었습니다';
  }

  @override
  String get appInfo => '앱 정보';

  @override
  String get appVersion => 'Nayza Vocab v1.0.0\nNayzadorlar를 위해 제작됨 🔱';

  @override
  String get language => '언어';

  @override
  String get uzbek => '우즈베크어';

  @override
  String get russian => '러시아어';

  @override
  String get english => '영어';

  @override
  String importSuccess(Object count) {
    return '$count개의 컬렉션을 성공적으로 가져왔습니다';
  }

  @override
  String importError(Object error) {
    return '가져오기 오류: $error';
  }

  @override
  String get historyTitle => '내 컬렉션';

  @override
  String get searchHint => '컬렉션 또는 단어 검색...';

  @override
  String get noResults => '결과 없음';

  @override
  String get noCollections => '아직 컬렉션이 없습니다';

  @override
  String get collectionsLabel => '컬렉션';

  @override
  String get foundWordsLabel => '찾은 단어';

  @override
  String get editWord => '단어 편집';

  @override
  String get editSetTitle => '컬렉션 이름 바꾸기';

  @override
  String get originalWord => '원래 단어';

  @override
  String get translationWord => '번역';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get wordUpdated => '단어 업데이트됨';

  @override
  String wordCountLabel(int count) {
    return '$count개 단어';
  }

  @override
  String setsCountLabel(int count) {
    return '$count개 세트';
  }

  @override
  String get selectCollectionsTitle => '컬렉션 선택';

  @override
  String get emptyCollectionsWarning => '먼저 하나 이상의 컬렉션을 만들어야 합니다.';

  @override
  String get selectAll => '모두 선택';

  @override
  String get deselectAll => '선택 취소';

  @override
  String get selectToStart => '시작하려면 선택하세요';

  @override
  String get emptySelectionWarning => '선택한 컬렉션이 비어 있습니다!';

  @override
  String get quizSetupTitle => '퀴즈 설정';

  @override
  String get selectQuizMode => '퀴즈 모드 선택';

  @override
  String get selectDirection => '퀴즈 방향';

  @override
  String get start => '시작';

  @override
  String get choiceMode => '객관식';

  @override
  String get choiceSubtitle => '4가지 옵션 중 선택';

  @override
  String get inputMode => '쓰기';

  @override
  String get inputSubtitle => '직접 답을 입력하세요';

  @override
  String get flashcardMode => '플래시카드';

  @override
  String get flashcardSubtitle => '클래식 반복';

  @override
  String get matchingMode => '매칭';

  @override
  String get matchingSubtitle => '쌍 찾기';

  @override
  String get originalToTranslation => '원본 -> 번역';

  @override
  String get translationToOriginal => '번역 -> 원본';

  @override
  String get randomDirection => '혼합 (무작위)';

  @override
  String get originalToTranslationSubtitle => '예: 영어 -> 우즈베크어';

  @override
  String get translationToOriginalSubtitle => '예: 우즈베크어 -> 영어';

  @override
  String get randomDirectionSubtitle => '무작위로 번갈아가며';

  @override
  String correctAnswerLabel(String answer) {
    return '정답: $answer';
  }

  @override
  String get typeTranslationHint => '번역 입력...';

  @override
  String get summaryTitle => '퀴즈 요약';

  @override
  String scoreLabel(int score) {
    return '당신의 점수: $score';
  }

  @override
  String correctCountLabel(Object count) {
    return '맞음: $count';
  }

  @override
  String incorrectCountLabel(Object count) {
    return '틀림: $count';
  }

  @override
  String get finish => '완료';

  @override
  String get tryAgain => '다시 시도';

  @override
  String learnedWordsCount(Object count) {
    return '이 세션에서 $count 단어를 마스터했습니다!';
  }

  @override
  String get flashcardLabel => '플래시카드';

  @override
  String get knowWord => '알아요';

  @override
  String get dontKnowWord => '몰라요';

  @override
  String get matchingGameTitle => '매칭 게임';

  @override
  String get findPairsLabel => '쌍 찾기';

  @override
  String stageLabel(int count) {
    return '단계 $count';
  }

  @override
  String get gameOverTitle => '게임 오버!';

  @override
  String get createSetTitle => '새 컬렉션';

  @override
  String get collectionNameLabel => '컬렉션 이름';

  @override
  String get collectionNameHint => '예: 여행, 가족...';

  @override
  String get nameRequiredError => '이름을 입력하세요';

  @override
  String get languageLabel => '학습 언어';

  @override
  String get englishLang => '영어';

  @override
  String get arabicLang => '아랍어';

  @override
  String get russianLang => '러시아어';

  @override
  String get uzbekLang => '우즈베크어';

  @override
  String get germanLang => '독일어';

  @override
  String get koreanLang => '한국어';

  @override
  String get wordPlaceholder => '단어';

  @override
  String get translationPlaceholder => '번역';

  @override
  String get addRowButton => '행 추가';

  @override
  String get atLeastOneWordWarning => '하나 이상의 단어를 입력하세요';

  @override
  String get setNotFound => '컬렉션을 찾을 수 없습니다.';

  @override
  String get deleteSetTitle => '컬렉션 삭제';

  @override
  String deleteSetConfirmation(String title) {
    return '\"$title\" 컬렉션을 삭제하시겠습니까?';
  }

  @override
  String get delete => '삭제';

  @override
  String get addWord => '단어 추가';

  @override
  String get emptySetWarning => '이 컬렉션은 비어 있습니다.';

  @override
  String wordsFoundCount(int count) {
    return '사용 가능한 단어 $count개';
  }

  @override
  String get masteryExplanation => '1번 올바르게 대답하면 단어를 마스터한 것으로 간주됩니다';

  @override
  String get progressLabel => '진행률';

  @override
  String get selectSetsTitle => '컬렉션 선택';

  @override
  String get selectAtLeastOneSet => '적어도 하나의 컬렉션을 선택하세요.';

  @override
  String get exportSuccess => '내보내기가 성공적으로 완료되었습니다!';

  @override
  String get shareSuccess => '성공적으로 공유되었습니다!';

  @override
  String shareSubject(Object title) {
    return 'NayzaVocab: $title';
  }

  @override
  String shareMessage(Object count, Object lang, Object title) {
    return '📚 Nayza Vocab 컬렉션: $title\n🌐 언어: $lang\n📝 단어 수: $count\n\n함께 학습하려면 이 파일을 Nayza Vocab으로 가져오세요!';
  }

  @override
  String get importedSuffix => '(가져옴)';

  @override
  String exportError(String error) {
    return '내보내기 오류: $error';
  }

  @override
  String wordsCountLabel(int count) {
    return '$count 단어';
  }

  @override
  String exportAction(Object count) {
    return '내보내기 ($count)';
  }

  @override
  String get onboardingWelcome => 'NAYZA VOCAB에 오신 것을 환영합니다';

  @override
  String get onboardingPage1Title => '어휘력 마스터';

  @override
  String get onboardingPage1Subtitle =>
      '과학적으로 입증된 방법으로 새로운 단어를 배우고 기억하는 가장 강력한 방법입니다.';

  @override
  String get onboardingPage2Title => '플래시카드 및 게임';

  @override
  String get onboardingPage2Subtitle => '학습에 중독되게 만드는 대화형 퀴즈 및 매칭 게임.';

  @override
  String get onboardingPage3Title => '진행 상황 추적';

  @override
  String get onboardingPage3Subtitle =>
      '시간이 지남에 따라 향상되는 것을 확인하고 어려운 단어에 집중하세요.';

  @override
  String get onboardingGetStarted => '시작하기';

  @override
  String get skip => '건너뛰기';

  @override
  String get submitAnswer => '확인';

  @override
  String get collectionsPageTitle => '컬렉션';

  @override
  String get cancelReminder => '알림 취소';

  @override
  String get resetAllData => '모든 데이터 초기화';

  @override
  String get resetAllDataConfirm => '이렇게 하면 모든 컬렉션과 진행 상황이 영구적으로 삭제됩니다. 확실합니까?';

  @override
  String get deleteSetConfirm => '이 컬렉션을 삭제하시겠습니까?';

  @override
  String get communityAndUpdates => '커뮤니티 및 업데이트';

  @override
  String get telegramChannel => '텔레그램 채널';

  @override
  String get telegramSubtitle => '팁과 업데이트를 위해 가입하세요';

  @override
  String get checkForUpdates => '업데이트 확인';

  @override
  String get checkForUpdatesSubtitle => 'Nayza Vocab의 최신 버전을 받으세요';

  @override
  String get onboardingPage4Title => '어떻게 작동하나요?';

  @override
  String get onboardingPage4Subtitle =>
      '체계적인 반복을 통해 단어를 마스터하세요. 어려운 단어는 완전히 외울 때까지 더 자주 나타납니다.';

  @override
  String get library => '라이브러리';

  @override
  String get createFolder => '새 폴더';

  @override
  String get folderName => '폴더 이름';

  @override
  String get create => '만들기';

  @override
  String get enterFolderName => '폴더 이름 입력';

  @override
  String get noFolder => '폴더 외부 (기본)';

  @override
  String get uncategorized => '미분류';

  @override
  String get dangerZone => '위험 구역';

  @override
  String shareError(Object error) {
    return '공유 오류: $error';
  }

  @override
  String get rename => '이름 바꾸기';

  @override
  String get onlineLibraryTitle => 'NAYZA 클라우드 라이브러리';

  @override
  String get allTopics => '모든 주제';

  @override
  String wordCountLabel_short(Object count) {
    return '$count 단어';
  }

  @override
  String get downloadAll => '모두 다운로드';

  @override
  String get installed => '설치됨';

  @override
  String get downloading => '다운로드 중...';

  @override
  String get deleteFolderConfirm => '이 폴더를 삭제하면 모든 세트와 단어도 삭제됩니다. 정말 삭제하시겠습니까?';

  @override
  String get connectionError => '연결 오류';

  @override
  String get noInternetMessage => '인터넷 연결을 확인하고 다시 시도하십시오.';

  @override
  String get noResultsFound => '결과를 찾을 수 없음';

  @override
  String get clearFilters => '필터 초기화';

  @override
  String get all => '모두';

  @override
  String get allDataCleared => '모든 데이터가 성공적으로 삭제되었습니다!';

  @override
  String get share => '공유';

  @override
  String get home => '홈';

  @override
  String get profile => '프로필';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get userName => '사용자 이름';

  @override
  String get userAge => '나이';

  @override
  String get targetLanguage => '학습 언어';

  @override
  String get folderBreakdown => '폴더 및 언어 분석';

  @override
  String get subjectBreakdown => '컬렉션 분석';

  @override
  String yearsOld(int age) {
    return '$age세';
  }

  @override
  String get masteredWords => '완료됨';

  @override
  String get smartPasteTitle => '스마트 붙여넣기';

  @override
  String get smartPasteHint => '단어 - 번역\n다른 단어 = 다른 번역';

  @override
  String get userNameHint => '이름';

  @override
  String get invalidAgeError => '올바른 나이를 입력하세요 (1-120)';

  @override
  String get folders => '폴더';

  @override
  String masteredPercentage(int percentage) {
    return '$percentage% 완료됨';
  }

  @override
  String get showLess => '접기';

  @override
  String showAllWithCount(int count) {
    return '모두 보기 ($count)';
  }

  @override
  String get rankNovice => '🛡️ 초보 전사';

  @override
  String get rankAdvanced => '⚔️ 숙련된 전사';

  @override
  String get rankCommander => '🔱 나이자 사령관';

  @override
  String get rankWordMaster => '👑 단어의 달인';

  @override
  String get latestVersionInstalled => '최신 버전이 설치되어 있습니다';

  @override
  String get updateAvailable => '새 업데이트 가능';

  @override
  String get updateNow => '지금 업데이트';

  @override
  String get downloadingUpdate => '업데이트 다운로드 중...';

  @override
  String get updateCheckFailed => '업데이트 확인 실패';

  @override
  String get whatsNew => '새로운 기능';

  @override
  String get openInBrowser => '브라우저에서 다운로드';

  @override
  String get audioSpeed => '발음 속도';

  @override
  String get speedSlow => '느리게 (0.75x)';

  @override
  String get speedNormal => '보통 (1.0x)';

  @override
  String get speedFast => '빠르게 (1.25x)';
}
