import 'package:flutter/material.dart';

/// 부모가 IgnorePadding인 경우 동작함
///
/// Ignore로 감싸진 위젯은 패딩 제어
class Ignore extends StatelessWidget {
  const Ignore({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}