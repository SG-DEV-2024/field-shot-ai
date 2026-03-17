extension WtObjectExtension on Object? {
  int? toInt() {
    if (this is String) {
      return toInt();
    } else if (this is num) {
      return toInt();
    } else if (this is bool) {
      return toInt();
    } else {
      return null;
    }
  }

  double? toDouble() {
    if (this is String) {
      return toDouble();
    } else if (this is num) {
      return toDouble();
    } else {
      return null;
    }
  }
}

/// Kotlin-style scope function extension for non-null types
extension LetExtension<T extends Object> on T {
  /// Calls the specified function [block] with `this` value as its argument and returns its result.
  /// 
  /// Example:
  /// ```dart
  /// final result = someValue.let((it) => it.someMethod());
  /// ```
  R let<R>(R Function(T) block) {
    return block(this);
  }
}

/// Kotlin-style scope function extension for nullable types
extension NullableLetExtension<T extends Object> on T? {
  /// Calls the specified function [block] with `this` value as its argument and returns its result.
  /// Returns null if `this` is null.
  /// 
  /// Example:
  /// ```dart
  /// final result = someNullableValue?.let((it) => it.someMethod());
  /// ```
  R? let<R>(R Function(T) block) {
    final self = this;
    if (self == null) return null;
    return block(self);
  }
}
