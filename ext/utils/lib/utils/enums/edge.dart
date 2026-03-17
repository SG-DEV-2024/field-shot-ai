import 'package:utils/utils.dart';

enum Edge {
  none,
  subtitle,
  footnote,
  hor8,
  hor16,
  more,
  ;

  EdgeInsets calc([double? limitRight]) {
    var insets = switch (this) {
      subtitle => const EdgeInsets.symmetric(horizontal: 48.0),
      //xx footnote => EdgeInsets.only(left: fontRepo.numberWidth + 16.0, right: 8.0),
      hor8 => const EdgeInsets.symmetric(horizontal: 8.0),
      hor16 => const EdgeInsets.symmetric(horizontal: 16.0),
      more => const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      _ => EdgeInsets.zero,
    };

    if (limitRight != null) {
      double right = maxWidth - limitRight;
      if (right > 0.0) insets = insets + EdgeInsets.only(right: right);
    }
    return insets;
  }
}
