import 'package:flutter_test/flutter_test.dart';
import 'package:nayza_vocab/core/models/app_update_info.dart';

void main() {
  group('AppUpdateInfo Semver Comparison Tests', () {
    test('Identifies newer minor/patch versions correctly', () {
      expect(AppUpdateInfo.isNewerVersion('1.0.2', '1.0.1'), isTrue);
      expect(AppUpdateInfo.isNewerVersion('v1.0.2', '1.0.1'), isTrue);
      expect(AppUpdateInfo.isNewerVersion('1.1.0', '1.0.9'), isTrue);
      expect(AppUpdateInfo.isNewerVersion('2.0.0', '1.9.9'), isTrue);
    });

    test('Identifies older or same versions as not newer', () {
      expect(AppUpdateInfo.isNewerVersion('1.0.1', '1.0.1'), isFalse);
      expect(AppUpdateInfo.isNewerVersion('v1.0.1', '1.0.1'), isFalse);
      expect(AppUpdateInfo.isNewerVersion('1.0.0', '1.0.1'), isFalse);
      expect(AppUpdateInfo.isNewerVersion('0.9.9', '1.0.0'), isFalse);
    });

    test('Handles build numbers and extra tags safely', () {
      expect(AppUpdateInfo.isNewerVersion('1.0.2+3', '1.0.1+2'), isTrue);
      expect(AppUpdateInfo.isNewerVersion('1.0.1+5', '1.0.1+2'), isFalse);
      expect(AppUpdateInfo.isNewerVersion('v1.2.0-beta', '1.1.0'), isTrue);
    });
  });
}
