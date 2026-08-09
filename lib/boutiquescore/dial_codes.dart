/// ITU dial codes for form countries (ISO-2 → calling code without +).
abstract final class DialCodes {
  static const Map<String, int> byIso2 = {
    'CM': 237,
    'SN': 221,
    'CI': 225,
    'ML': 223,
    'BF': 226,
    'GN': 224,
    'CD': 243,
    'CG': 242,
    'GA': 241,
    'TG': 228,
    'BJ': 229,
    'NE': 227,
    'TD': 235,
    'CF': 236,
    'GQ': 240,
  };

  static int? forCountry(String iso2) =>
      byIso2[iso2.trim().toUpperCase()];

  static String displayPrefix(String iso2) {
    final code = forCountry(iso2);
    return code == null ? '' : '+$code';
  }
}
