import 'package:utils/utils.dart';

// xxx 패딩 정리 요망
//*************************** Padding ***************************
class WtPadding {
  WtPadding._();

  static const zero = EdgeInsets.zero;

  /// 상하좌우 패딩 4 적용
  ///
  /// ```dart
  /// EdgeInsets.all(4.0);
  /// ```
  static const all4 = EdgeInsets.all(4.0);

  /// 상하좌우 패딩 8 적용
  ///
  /// ```dart
  /// EdgeInsets.all(8.0);
  /// ```
  static const all8 = EdgeInsets.all(8.0);

  /// 상하좌우 패딩 16 적용
  ///
  /// ```dart
  /// EdgeInsets.all(16.0);
  /// ```
  static const all16 = EdgeInsets.all(16.0);

  /// 좌우 패딩 8 적용
  ///
  /// ```dart
  /// EdgeInsets.symmetric(horizontal: 8.0);
  /// ```
  static const horizontal8 = EdgeInsets.symmetric(horizontal: 8.0);

  /// 좌우 패딩 16 적용
  ///
  /// ```dart
  /// EdgeInsets.symmetric(horizontal: 16.0);
  /// ```
  static const horizontal16 = EdgeInsets.symmetric(horizontal: 16.0);

  /// 좌우 패딩 24 적용
  ///
  /// ```dart
  /// EdgeInsets.symmetric(horizontal: 24.0);
  /// ```
  static const horizontal24 = EdgeInsets.symmetric(horizontal: 24.0);

  /// 좌우 패딩 16, 상하 8 적용
  ///
  /// ```dart
  /// EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  /// ```
  static const horizontal16vertical8 = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  /// 상하 패딩 8 적용
  ///
  /// ```dart
  /// EdgeInsets.symmetric(vertical: 8.0);
  /// ```
  static const vertical8 = EdgeInsets.symmetric(vertical: 8.0);

  /// 상하 패딩 16 적용
  ///
  /// ```dart
  /// EdgeInsets.symmetric(vertical: 16.0);
  /// ```
  static const vertical16 = EdgeInsets.symmetric(vertical: 16.0);

  /// 상 패딩 8 적용
  ///
  /// ```dart
  /// EdgeInsets.only(top: 8);
  /// ```
  static const top8 = EdgeInsets.only(top: 8);

  /// 상 패딩 16 적용
  ///
  /// ```dart
  /// EdgeInsets.only(top: 16);
  /// ```
  static const top16 = EdgeInsets.only(top: 16);

  /// 하 패딩 8 적용
  ///
  /// ```dart
  /// EdgeInsets.only(bottom: 8);
  /// ```
  static const bottom8 = EdgeInsets.only(bottom: 8);

  /// 하 패딩 16 적용
  ///
  /// ```dart
  /// EdgeInsets.only(bottom: 16);
  /// ```
  static const bottom16 = EdgeInsets.only(bottom: 16);

  /// 하 패딩 32 적용
  ///
  /// ```dart
  /// EdgeInsets.only(bottom: 16);
  /// ```
  static const bottom32 = EdgeInsets.only(bottom: 32);

  /// 좌 패딩 8 적용
  ///
  /// ```dart
  /// EdgeInsets.only(left: 8);
  /// ```
  static const left8 = EdgeInsets.only(left: 8);

  /// 좌 패딩 16 적용
  ///
  /// ```dart
  /// EdgeInsets.only(left: 16);
  /// ```
  static const left16 = EdgeInsets.only(left: 16);

  /// 우 패딩 8 적용
  ///
  /// ```dart
  /// EdgeInsets.only(right: 8);
  /// ```
  static const right8 = EdgeInsets.only(right: 8);

  /// 우 패딩 16 적용
  ///
  /// ```dart
  /// EdgeInsets.only(right: 16);
  /// ```
  static const right16 = EdgeInsets.only(right: 16);

  /// 우 패딩 16 적용
  ///
  /// ```dart
  /// EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 24);
  /// ```
  static const ltr16b24 = EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 24);
}
