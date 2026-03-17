extension WtDynamicExtension on dynamic {
  /// enum 문자열변환 확장
  ///
  /// Example:
  /// ```dart
  /// TODAY.MONDAY.enumToString // 'MONDAY'
  /// ```
  String? enumToString() {
    return this == null ? null : toString().split('.').last;
  }
}
