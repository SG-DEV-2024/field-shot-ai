extension WtDoubleExtension on double? {
  String toStringOrEmpty() => this == null ? '' : this!.toString();

  bool get isNullNaN => this == null || this!.isNaN;

  bool get isNotNullNaN => this != null && !this!.isNaN;

  String toStringAsTiltN([int fixed = 2]) {
    try {
      if (isNullNaN) return '---';
      return '${this! < 0 ? '' : '+'}${this!.toStringAsFixed(fixed)}';
    } catch (error) {
      return '';
    }
  }

  String toStringAsTiltNDelta() {
    try {
      if (this == null) {
        return '측량범위 초과';
      } else if (this!.isNaN) {
        return '변화없음';
      }
      return '${this! < 0 ? '-' : '+'}1/${this!.abs().toStringAsFixed(0)}';
    } catch (error) {
      return '';
    }
  }

  double safeValue([double defaultValue = 0.0]) {
    if (this == null || this!.isNaN) {
      return defaultValue;
    }
    return this!;
  }
}
