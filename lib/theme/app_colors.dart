import 'package:flutter/material.dart';

/// 화면설계서 §4 디자인 시스템 색상 토큰 (12종).
///
/// Tailwind 팔레트 가중치(weight) 네이밍을 따른다 — 숫자가 클수록 진한 색.
/// 예) [ink900] 본문, [ink500] 보조. 새 색이 필요하면 같은 규칙으로 추가.
abstract class AppColors {
  // ── Blue : 시작점 · 활성 · 업로드 ─────────────────────
  static const Color blue600 = Color(0xFF2563EB); // 시작점·활성 (blue)
  static const Color blue800 = Color(0xFF1E40AF); // 일괄 업로드 (blue-deep)
  static const Color blue50 = Color(0xFFEFF6FF); // 활성 카드 bg (blue-weak)

  // ── Red : 끝점 · 대기 · 에러 ─────────────────────────
  static const Color red500 = Color(0xFFEF4444); // 끝점 (red)
  static const Color red600 = Color(0xFFDC2626); // 대기중·에러 (red-strong)

  // ── Yellow / Amber : 가이드 · 홀 ───────────────────────
  static const Color yellow400 = Color(0xFFFACC15); // 가이드박스 (yellow)
  static const Color amber500 = Color(0xFFF59E0B); // 홀 입구 (amber)
  static const Color amber100 = Color(0xFFFEF3C7); // 홀 깊이 톤 (amber-weak)

  // ── Green : 완료 · ON ────────────────────────────────
  static const Color green600 = Color(0xFF16A34A); // 완료·ON (green)
  static const Color green100 = Color(0xFFDCFCE7); // ON pill bg (green-weak)

  // ── Ink : 텍스트 ─────────────────────────────────────
  static const Color ink900 = Color(0xFF111827); // 본문 (ink)
  static const Color ink500 = Color(0xFF6B7280); // 보조 (muted)
}
