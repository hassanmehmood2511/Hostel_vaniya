/// Display helpers for currency and counts (PKR, Pakistani digit grouping
/// kept simple with thousands separators as used in the designs).
abstract final class Fmt {
  static String _group(int value) {
    final String s = value.abs().toString();
    final StringBuffer out = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) out.write(',');
      out.write(s[i]);
    }
    return value < 0 ? '-$out' : out.toString();
  }

  /// `Rs 12,000`
  static String rs(int amount) => 'Rs ${_group(amount)}';

  /// `Rs 12k`, `Rs 9.5k`
  static String rsShort(int amount) {
    if (amount < 1000) return 'Rs $amount';
    final double k = amount / 1000;
    final String txt = k == k.roundToDouble() ? k.toStringAsFixed(0) : k.toStringAsFixed(1);
    return 'Rs ${txt}k';
  }

  /// `1,248`
  static String count(int value) => _group(value);

  static String km(double value) => '${value.toStringAsFixed(1)} km';

  static String initials(String name) {
    final List<String> parts =
        name.trim().split(RegExp(r'\s+')).where((String p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }
}
