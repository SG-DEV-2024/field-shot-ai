import 'package:utils/utils.dart';

enum WtAspectRatio {
  ratio_1x1,
  ratio_2x3,
  ratio_16x9,
  ratio_21x9,
}

enum CloseButtonType {
  // ignore: constant_identifier_names
  in_close,
  // ignore: constant_identifier_names
  out_close,
}

extension WtRatioExtension on WtAspectRatio {
  double toConvertDouble() {
    if (this == WtAspectRatio.ratio_1x1) {
      return 1;
    } else if (this == WtAspectRatio.ratio_2x3) {
      return 2 / 3;
    } else if (this == WtAspectRatio.ratio_16x9) {
      return 16 / 9;
    } else if (this == WtAspectRatio.ratio_21x9) {
      return 21 / 9;
    } else {
      return 1;
    }
  }

  int get getRatioX {
    if (this == WtAspectRatio.ratio_1x1) {
      return 1;
    } else if (this == WtAspectRatio.ratio_2x3) {
      return 2;
    } else if (this == WtAspectRatio.ratio_16x9) {
      return 16;
    } else if (this == WtAspectRatio.ratio_21x9) {
      return 21;
    } else {
      return 1;
    }
  }

  int get getRatioY {
    if (this == WtAspectRatio.ratio_1x1) {
      return 1;
    } else if (this == WtAspectRatio.ratio_2x3) {
      return 3;
    } else if (this == WtAspectRatio.ratio_16x9) {
      return 9;
    } else if (this == WtAspectRatio.ratio_21x9) {
      return 9;
    } else {
      return 1;
    }
  }
}
