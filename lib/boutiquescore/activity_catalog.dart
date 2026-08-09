// Activity catalog aligned with protos_weebi BusinessClassifications.all
// (source of truth: weebi_server/.../business_classifications.dart).
// Composite key: ([isicCode], [subCode]).

class ActivityRow {
  const ActivityRow({
    required this.isicCode,
    required this.subCode,
    required this.emoji,
    required this.labelFr,
  });

  final String isicCode;
  final String subCode;
  final String emoji;
  final String labelFr;

  String get compositeKey =>
      subCode.isEmpty ? isicCode : '$isicCode:$subCode';

  String get displayLabel => '$emoji $labelFr';
}

abstract final class ActivityCatalog {
  static ActivityRow? byIsicAndSub(String isicCode, [String subCode = '']) {
    final isic = isicCode.trim();
    if (isic.isEmpty) return null;
    final sub = subCode.trim();
    for (final row in all) {
      if (row.isicCode == isic && row.subCode == sub) return row;
    }
    return null;
  }

  static ActivityRow? byCompositeKey(String key) {
    final parts = key.split(':');
    if (parts.length == 1) return byIsicAndSub(parts[0]);
    return byIsicAndSub(parts[0], parts.sublist(1).join(':'));
  }

  static final List<ActivityRow> all = List.unmodifiable([
    const ActivityRow(isicCode: '4719', subCode: '', emoji: '🛍️', labelFr: 'Boutique'),
    const ActivityRow(isicCode: '4711', subCode: '', emoji: '🥫', labelFr: 'Alimentation générale'),
    const ActivityRow(isicCode: '4771', subCode: 'bambinerie', emoji: '🧸', labelFr: 'Bambinerie'),
    const ActivityRow(isicCode: '5630', subCode: '', emoji: '🍹', labelFr: 'Bar'),
    const ActivityRow(isicCode: '1071', subCode: '', emoji: '🍞', labelFr: 'Boulangerie'),
    const ActivityRow(isicCode: '4721', subCode: 'boucherie', emoji: '🥩', labelFr: 'Boucherie'),
    const ActivityRow(isicCode: '1103', subCode: '', emoji: '🍺', labelFr: 'Brasserie'),
    const ActivityRow(isicCode: '4773', subCode: '', emoji: '💄', labelFr: 'Cosmétique'),
    const ActivityRow(isicCode: '014', subCode: '', emoji: '🐄', labelFr: 'Élevage bovin/ovin/etc.'),
    const ActivityRow(isicCode: '0322', subCode: '', emoji: '🐟', labelFr: 'Pisciculture'),
    const ActivityRow(isicCode: '4740', subCode: 'electronique', emoji: '📱', labelFr: 'Électronique'),
    const ActivityRow(isicCode: '4740', subCode: 'informatique', emoji: '💻', labelFr: 'Informatique'),
    const ActivityRow(isicCode: '4759', subCode: '', emoji: '🔌', labelFr: 'Électroménager'),
    const ActivityRow(isicCode: '4721', subCode: 'epicerie', emoji: '🍏', labelFr: 'Épicerie'),
    const ActivityRow(isicCode: '5510', subCode: '', emoji: '🏨', labelFr: 'Hôtel'),
    const ActivityRow(isicCode: '1811', subCode: '', emoji: '🖨️', labelFr: 'Imprimerie'),
    const ActivityRow(isicCode: '4763', subCode: '', emoji: '🎲', labelFr: 'Jeux'),
    const ActivityRow(isicCode: '1622', subCode: '', emoji: '🪵', labelFr: 'Menuiserie bois'),
    const ActivityRow(isicCode: '2511', subCode: '', emoji: '⚙️', labelFr: 'Menuiserie métallique'),
    const ActivityRow(isicCode: '3100', subCode: '', emoji: '🪑', labelFr: 'Fabrication de meubles en bois'),
    const ActivityRow(isicCode: '8299', subCode: '', emoji: '🛠️', labelFr: 'Multi-services'),
    const ActivityRow(isicCode: '4761', subCode: '', emoji: '📚', labelFr: 'Papeterie'),
    const ActivityRow(isicCode: '4772', subCode: '', emoji: '💊', labelFr: 'Pharmacie'),
    const ActivityRow(isicCode: '4782', subCode: '', emoji: '🚗', labelFr: 'Pièces détachées auto'),
    const ActivityRow(isicCode: '4783', subCode: '', emoji: '🏍️', labelFr: 'Pièces détachées moto'),
    const ActivityRow(isicCode: '4721', subCode: 'poissonnerie', emoji: '🐟', labelFr: 'Poissonnerie'),
    const ActivityRow(isicCode: '4771', subCode: 'pret_a_porter', emoji: '👗', labelFr: 'Prêt-à-porter'),
    const ActivityRow(isicCode: '4752', subCode: '', emoji: '🔨', labelFr: 'Quincaillerie'),
    const ActivityRow(isicCode: '5610', subCode: '', emoji: '🍽️', labelFr: 'Restaurant'),
    const ActivityRow(isicCode: '9602', subCode: 'coiffure', emoji: '💇', labelFr: 'Salon de coiffure'),
    const ActivityRow(isicCode: '9602', subCode: 'beaute', emoji: '💅', labelFr: 'Salon de beauté'),
    const ActivityRow(isicCode: '1410', subCode: '', emoji: '✂️', labelFr: 'Tailleur'),
    const ActivityRow(isicCode: '8610', subCode: 'clinique', emoji: '🏥', labelFr: 'Clinique / hôpital'),
    const ActivityRow(isicCode: '8620', subCode: 'medical', emoji: '🩺', labelFr: 'Cabinet médical'),
    const ActivityRow(isicCode: '8620', subCode: 'dentaire', emoji: '🦷', labelFr: 'Cabinet dentaire'),
    const ActivityRow(isicCode: '8610', subCode: 'maternite', emoji: '🤱', labelFr: 'Maternité'),
    const ActivityRow(isicCode: '9311', subCode: '', emoji: '🏅', labelFr: 'Sport et fitness'),
  ]);
}
