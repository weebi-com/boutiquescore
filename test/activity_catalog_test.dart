import 'package:test/test.dart';
import 'package:wasm/boutiquescore.dart';

void main() {
  group('ActivityCatalog', () {
    test('looks up Boulangerie by isic 1071', () {
      final row = ActivityCatalog.byIsicAndSub('1071');
      expect(row, isNotNull);
      expect(row!.labelFr, 'Boulangerie');
      expect(row.compositeKey, '1071');
    });

    test('looks up Bambinerie by isic + sub', () {
      final row = ActivityCatalog.byIsicAndSub('4771', 'bambinerie');
      expect(row, isNotNull);
      expect(row!.labelFr, 'Bambinerie');
      expect(ActivityCatalog.byCompositeKey('4771:bambinerie')?.labelFr,
          'Bambinerie');
    });

    test('unknown returns null', () {
      expect(ActivityCatalog.byIsicAndSub('9999'), isNull);
    });
  });
}
