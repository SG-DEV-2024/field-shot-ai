extension WtIntExtension on int? {
  String toStringOrEmpty() => this == null ? '' : this!.toString();

  String toDigits(int width) => toString().padLeft(width, '0');

  /// 사업자등록번호로 변환
  ///
  /// Example:
  /// ```dart
  /// 123456789.toCurrency(); // '123,456,789'
  /// ```
  String toBRN() {
    if (this == null) return "";
    final high = this! ~/ 10000000;
    final mid = (this! ~/ 100000) % 100;
    final low = this! % 100000;

    return '${high.toDigits(3)}-${mid.toDigits(2)}-${low.toDigits(5)}';
  }

  static const chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const base62 = chars.length;
  static const base36 = 36;

  // Function to convert a number to base62
  String toBase62({int width = 4}) {
    if (this == null || this == 0) return chars[0].padLeft(width, '0');
    final result = StringBuffer();
    var num = this!;
    while (num > 0) {
      result.write(chars[num % base62]);
      num ~/= base62;
    }
    return result.toString().split('').reversed.join().padLeft(width, '0');
  }

  // Function to convert base62 string back to number
  static int fromBase62(String str) {
    int result = 0;
    for (final char in str.split('')) {
      result = result * base62 + chars.indexOf(char);
    }
    return result;
  }

  String toBase36({int width = 5}) {
    if (this == null || this == 0) return chars[0].padLeft(width, '0');
    final result = StringBuffer();
    var num = this!;
    while (num > 0) {
      result.write(chars[num % base36]);
      num ~/= base36;
    }
    return result.toString().split('').reversed.join().padLeft(width, '0');
  }

  String toHex({int width = 8}) {
    if (this == null || this == 0) return chars[0].padLeft(width, '0');
    final result = StringBuffer();
    var num = this!;
    while (num > 0) {
      result.write(chars[num % 16]);
      num ~/= 16;
    }
    return result.toString().split('').reversed.join().padLeft(width, '0');
  }

  String toFileSize() {
    if (this == null) return '';
    const int kB = 1024;
    const int mB = 1024 * 1024;
    const int gB = 1024 * 1024 * 1024;

    if (this! >= gB) {
      double sizeInGB = this! / gB;
      return "${sizeInGB.toStringAsFixed(2)} GB";
    } else if (this! >= mB) {
      double sizeInMB = this! / mB;
      return "${sizeInMB.toStringAsFixed(2)} MB";
    } else if (this! >= kB) {
      double sizeInKB = this! / kB;
      return "${sizeInKB.toStringAsFixed(2)} KB";
    } else {
      return "${this!} B";
    }
  }
}
