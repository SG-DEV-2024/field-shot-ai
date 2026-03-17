import 'package:utils/utils.dart';

class WtIconButton extends StatelessWidget {
  /// 이미지 버튼
  const WtIconButton({
    super.key,
    required this.icon,
    this.buttonSize = 40,
    this.iconSize = 24,
    this.iconColor,
    this.useThemeColor = false,
    this.title,
    this.decoration,
    this.showTapEffect = false,
    required this.onPressed,
  });

  /// 아이콘
  final dynamic icon;

  /// 버튼 사이즈
  final double buttonSize;

  /// 아이콘 사이즈
  final double iconSize;

  /// 아이콘 색상
  final Color? iconColor;

  /// 테마 색상 사용
  final bool useThemeColor;

  /// 아이콘 제목
  final String? title;

  /// 버튼 데코레이션
  final Decoration? decoration;

  /// 클릭 이펙트 표시여부
  final bool showTapEffect;

  /// 버튼 클릭 이벤트
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: buttonSize, minWidth: buttonSize),
      child: InkWell(
        onTap: onPressed,
        hoverColor: showTapEffect ? null : Colors.transparent,
        highlightColor: showTapEffect ? null : Colors.transparent,
        splashColor: showTapEffect ? null : Colors.transparent,
        onDoubleTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon is IconData)
              Icon(
                icon,
                size: iconSize,
                color: iconColor,
                // useThemeColor: useThemeColor,
              )
            else
              icon as Widget,
            if (title != null) ...[
              const SizedBox(height: 1),
              Text(
                title.toString(),
                style: WtTextStyle.labelMedium.copyWith(color: WtColors.gray2),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
