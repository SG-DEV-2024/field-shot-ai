import 'package:utils/utils.dart';

class WtListItem extends StatelessWidget {
  WtListItem({
    Key? key,
    required this.title,
    this.titleTextStyle,
    this.titleWidth,
    this.minHeight = 48,
    this.content,
    this.contentTextStyle,
    this.contentAlignment = Alignment.centerRight,
    this.maxLines = 1,
    this.usePortraitMode = false,
    this.onTap,
    this.isShowRightArrow,
  }) : super(key: key) {
    itemKey = 'WtListItem';
  }

  WtListItem.size16({
    Key? key,
    required this.title,
    this.titleTextStyle,
    this.titleWidth,
    this.minHeight = 48,
    required this.content,
    this.contentTextStyle,
    this.contentAlignment = Alignment.centerRight,
    this.maxLines = 1,
    this.onTap,
    this.isShowRightArrow,
  }) : super(key: key) {
    itemKey = 'WtListItem.size16';
    usePortraitMode = false;
  }

  /// 제목
  final String title;

  /// 제목 스타일
  final TextStyle? titleTextStyle;

  /// 제목 가로 사이즈
  final double? titleWidth;

  /// 최소 높이
  final double minHeight;

  /// 내용
  final String? content;

  /// 내용 스타일
  final TextStyle? contentTextStyle;

  /// 제목 정렬
  final AlignmentGeometry contentAlignment;

  /// 컨텐츠 최대라인
  final int maxLines;

  /// 세로모드 여부
  late final bool usePortraitMode;

  /// 키
  late final String itemKey;

  /// 클릭 이벤트
  late final VoidCallback? onTap;

  /// 우측 화살표 표시 여부
  final bool? isShowRightArrow;

  @override
  Widget build(BuildContext context) {
    if (itemKey == 'WtListItem') {
      if (usePortraitMode) {
        return InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                sizedBox8,
                Text(
                  title,
                  style: titleTextStyle ?? WtTextStyle.bodyMedium.gray2,
                  textAlign: TextAlign.left,
                ),
                sizedBox8,
                Text(
                  content ?? '',
                  style: contentTextStyle ?? WtTextStyle.bodyMedium.gray1,
                  textAlign: TextAlign.left,
                ),
                sizedBox8,
              ],
            ),
          ),
        ).isEffectOff();
      } else {
        return InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Row(
              children: [
                SizedBox(
                  width: titleWidth,
                  child: Text(
                    title,
                    style: titleTextStyle ?? WtTextStyle.bodyMedium.gray2,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: contentAlignment,
                    child: onTap != null
                        ? InkWell(
                            onTap: onTap,
                            child: Text(
                              content ?? '',
                              style: contentTextStyle ?? WtTextStyle.bodyMedium.primary,
                              maxLines: maxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Text(
                            content ?? '',
                            style: contentTextStyle ?? WtTextStyle.bodyMedium.gray1,
                            maxLines: maxLines,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ).isEffectOff();
      }
    } else {
      return InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight),
          child: Row(
            children: [
              SizedBox(
                width: titleWidth,
                child: Text(
                  title,
                  style: titleTextStyle ?? WtTextStyle.bodyLarge.onPrimaryContainer,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: contentAlignment,
                  child: Text(
                    content ?? '',
                    style: contentTextStyle ?? WtTextStyle.bodyLarge.gray2,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (onTap != null) (isShowRightArrow ?? true) == true ? const Icon(WtIcons.chevron_forward) : Container(),
            ],
          ),
        ),
      ).isEffectOff();
    }
  }
}
