import 'package:utils/utils.dart';

// ignore: must_be_immutable
class WtTitle extends StatelessWidget {
  /// 타이틀 30 타입
  ///
  /// Size 30
  ///
  /// Color black
  WtTitle.size30(this.text,
      {super.key, this.isMandatory = false, this.isContents = false, bool isBold = false, this.height})
      : isGrey = false,
        widget = _Size30(text: text, isMandatory: isMandatory, isBold: isBold, isContents: isContents, height: height);

  /// 타이틀 24 타입
  ///
  /// Size 24
  ///
  /// Color black
  WtTitle.size24(this.text,
      {super.key, this.isMandatory = false, this.isContents = false, bool isBold = false, this.height})
      : isGrey = false,
        widget = _Size24(text: text, isMandatory: isMandatory, isBold: isBold, isContents: isContents, height: height);

  /// 타이틀 20 타입
  ///
  /// Size 20
  ///
  /// Color black
  WtTitle.size20(this.text,
      {super.key, this.isMandatory = false, this.isContents = false, bool isBold = false, this.height})
      : isGrey = false,
        widget = _Size20(text: text, isMandatory: isMandatory, isBold: isBold, isContents: isContents, height: height);

  /// 서브타이틀 타입
  ///
  /// Size 16
  ///
  /// Color black or grey
  WtTitle.size16(this.text,
      {super.key,
      this.isGrey = false,
      bool isBold = false,
      this.isMandatory = false,
      this.isContents = false,
      this.height})
      : widget = _Size16(
            text: text,
            isGrey: isGrey,
            isBold: isBold,
            isMandatory: isMandatory,
            isContents: isContents,
            height: height);

  /// 서브타이틀 타입
  ///
  /// Size 14
  ///
  /// Color black or grey
  WtTitle.size14(this.text,
      {super.key, this.isGrey = false, this.isMandatory = false, this.isContents = false, this.height})
      : widget = _Size14(text: text, isGrey: isGrey, isMandatory: isMandatory, isContents: isContents, height: height);

  /// 서브타이틀
  ///
  /// Size 12
  ///
  /// Color black or grey
  WtTitle.size12(this.text,
      {super.key, this.isGrey = false, this.isMandatory = false, this.isContents = false, this.height})
      : widget = _Size12(text: text, isGrey: isGrey, isMandatory: isMandatory, isContents: isContents, height: height);

  /// 텍스트
  final String? text;

  /// 텍스트 회색 사용여부(기존:false)
  final bool isGrey;

  /// 필수값 표시 여부(기존:false)
  final bool isMandatory;

  /// 목차 여부(기존:false)
  final bool isContents;

  /// 높이
  final double? height;

  /// common widget
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}

class _Size12 extends StatelessWidget {
  const _Size12(
      {required this.text,
      required this.isGrey,
      required this.isMandatory,
      required this.isContents,
      required this.height});

  final String? text;
  final bool isGrey;
  final bool isMandatory;
  final bool isContents;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isContents) contentsWidget(isContents),
          if (isGrey) ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.bodySmall.gray2,
              ),
            ),
          ] else ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.bodySmall,
              ),
            ),
          ],
          if (isMandatory) mandatoryWidget(isMandatory, 12),
        ],
      ),
    );
  }
}

class _Size14 extends StatelessWidget {
  const _Size14(
      {required this.text,
      required this.isGrey,
      required this.isMandatory,
      required this.isContents,
      required this.height});

  final String? text;
  final bool isGrey;
  final bool isMandatory;
  final bool isContents;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isContents) contentsWidget(isContents),
          if (isGrey) ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.bodyMedium.gray2,
              ),
            ),
          ] else ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.bodyMedium,
              ),
            ),
          ],
          if (isMandatory) mandatoryWidget(isMandatory, 14),
        ],
      ),
    );
  }
}

class _Size16 extends StatelessWidget {
  const _Size16(
      {required this.text,
      required this.isGrey,
      required this.isBold,
      required this.isMandatory,
      required this.isContents,
      required this.height});

  final String? text;
  final bool isGrey;
  final bool isBold;
  final bool isMandatory;
  final bool isContents;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isContents) contentsWidget(isContents),
          if (isGrey) ...[
            Flexible(
              child: Text(
                text.toString(),
                style: isBold ? WtTextStyle.bodyLarge.medium.gray2 : WtTextStyle.bodyLarge.gray2,
              ),
            ),
          ] else ...[
            Flexible(
              child: Text(
                text.toString(),
                style: isBold ? WtTextStyle.bodyLarge.medium : WtTextStyle.bodyLarge,
              ),
            ),
          ],
          if (isMandatory) mandatoryWidget(isMandatory, 16),
        ],
      ),
    );
  }
}

class _Size20 extends StatelessWidget {
  const _Size20(
      {required this.text,
      required this.isMandatory,
      required this.isBold,
      required this.isContents,
      required this.height});

  final String? text;
  final bool isMandatory;
  final bool isBold;
  final bool isContents;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isContents) contentsWidget(isContents),
          if (isBold) ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.titleLarge.bold,
              ),
            ),
          ] else ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.titleLarge.medium,
              ),
            ),
          ],
          if (isMandatory) mandatoryWidget(isMandatory, 20),
        ],
      ),
    );
  }
}

class _Size24 extends StatelessWidget {
  const _Size24(
      {required this.text,
      required this.isMandatory,
      required this.isBold,
      required this.isContents,
      required this.height});

  final String? text;
  final bool isMandatory;
  final bool isBold;
  final bool isContents;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isContents) contentsWidget(isContents),
          if (isBold) ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.titleLarge.bold,
              ),
            ),
          ] else ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.titleLarge.medium,
              ),
            ),
          ],
          if (isMandatory) mandatoryWidget(isMandatory, 24),
        ],
      ),
    );
  }
}

class _Size30 extends StatelessWidget {
  const _Size30(
      {required this.text,
      required this.isMandatory,
      required this.isBold,
      required this.isContents,
      required this.height});

  final String? text;
  final bool isMandatory;
  final bool isBold;
  final bool isContents;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isContents) contentsWidget(isContents),
          if (isBold) ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.titleLarge.bold,
              ),
            ),
          ] else ...[
            Flexible(
              child: Text(
                text.toString(),
                style: WtTextStyle.titleLarge.medium,
              ),
            ),
          ],
          if (isMandatory) mandatoryWidget(isMandatory, 30),
        ],
      ),
    );
  }
}

/// 필수 표시
Padding mandatoryWidget(bool isMandatory, double? height) {
  return Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Column(
      children: [
        Container(
          width: 6,
          height: 6,
          alignment: Alignment.topCenter,
          decoration: isMandatory == true
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  color: WtColors.error,
                )
              : null,
        ),
        SizedBox(
          height: height,
        )
      ],
    ),
  );
}

/// 목차 표시
Padding contentsWidget(bool isMandatory) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Container(
      width: 4,
      height: 4,
      decoration: isMandatory
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: WtColors.onBackground,
            )
          : null,
    ),
  );
}
