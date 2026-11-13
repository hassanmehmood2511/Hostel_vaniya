/// Form validators. Messages are short and tell the user how to fix it.
abstract final class Validators {
  static String? required(String? v, {String field = 'This field'}) =>
      (v == null || v.trim().isEmpty) ? '$field is required' : null;

  /// Accepts 03XXXXXXXXX or +923XXXXXXXXX (spaces/dashes ignored).
  static String? pkPhone(String? v) {
    final String digits = (v ?? '').replaceAll(RegExp(r'[\s-]'), '');
    if (digits.isEmpty) return 'Phone number is required';
    final bool ok = RegExp(r'^(\+92|0)3\d{9}$').hasMatch(digits);
    return ok ? null : 'Enter a valid number, e.g. 0300 1234567';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Use at least 8 characters';
    return null;
  }
}
