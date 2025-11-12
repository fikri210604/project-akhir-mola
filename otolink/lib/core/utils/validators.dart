class Validators {
  static String? required(String? value, {String message = 'Wajib diisi'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? min(int? value, int minValue, {String? message}) {
    if (value == null) return message ?? 'Wajib diisi';
    if (value < minValue) return message ?? 'Minimal $minValue';
    return null;
  }
}
