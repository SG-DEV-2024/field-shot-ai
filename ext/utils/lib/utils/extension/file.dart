import 'dart:io';
import 'package:utils/utils/extension/_extension.dart';

extension WtFileExtension on File {
  ///
  ///
  /// Example:
  /// ```dart
  ///
  /// ```
  getFileSize({int decimals = 2}) {
    int bytes = lengthSync();
    return bytes.bytesToString(decimals: decimals);
  }
}
