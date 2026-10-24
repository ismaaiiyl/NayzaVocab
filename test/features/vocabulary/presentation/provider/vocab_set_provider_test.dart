import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';

class MockBox extends Mock implements Box<VocabSetModel> {}
class MockFolderBox extends Mock implements Box<FolderModel> {}
class FakeVocabSetModel extends Fake implements VocabSetModel {}
class FakeFolderModel extends Fake implements FolderModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeVocabSetModel());
    registerFallbackValue(FakeFolderModel());
  });

  group('VocabSetProvider Tests (Enterprise)', () {
    late MockBox mockBox;
    late MockFolderBox mockFolderBox;
    late VocabSetProvider provider;

    setUp(() {
      mockBox = MockBox();
      mockFolderBox = MockFolderBox();

      // Mock Box behavior 
      when(() => mockBox.values).thenReturn(<VocabSetModel>[]);
      when(() => mockBox.put(any<dynamic>(), any<VocabSetModel>())).thenAnswer((_) async => {});
      when(() => mockFolderBox.values).thenReturn(<FolderModel>[]);
      when(() => mockFolderBox.put(any<dynamic>(), any<FolderModel>())).thenAnswer((_) async => {});

      provider = VocabSetProvider(mockBox, mockFolderBox);
    });

    test('Initializes with empty sets', () {
      expect(provider.vocabSets.isEmpty, true);
    });
    
    test('addSet updates local list and saves to Box', () async {
      final newSet = VocabSetModel(
        id: '123',
        title: 'Test Set',
        createdAt: DateTime.now(),
        words: [],
      );

      // Tell the mock to return the set when values is called AFTER put
      when(() => mockBox.values).thenReturn([newSet]);

      await provider.addSet(newSet);

      expect(provider.vocabSets.length, 1);
      expect(provider.vocabSets.first.id, '123');
      final captured = verify(() => mockBox.put('123', captureAny())).captured;
      expect((captured.first as VocabSetModel).id, '123');
    });

    test('deleteVocabSet removes from box and reloads', () async {
      when(() => mockBox.delete(any<dynamic>())).thenAnswer((_) async => {});
      
      await provider.deleteVocabSet('123');
      
      verify(() => mockBox.delete('123')).called(1);
    });
  });
}
