//* Basic Package
export 'package:flutter/material.dart';
export 'package:flutter/cupertino.dart' hide RefreshCallback;

//* Dart Package
export 'dart:core';
export 'dart:collection';
export 'dart:io';
export 'dart:async';
export 'dart:convert';
export 'dart:typed_data';

//* Flutter Package
export 'package:flutter/foundation.dart';
export 'package:flutter/gestures.dart';
export 'package:flutter/services.dart';

export 'utils/abstract/_abstract.dart';
export 'utils/enums/_enums.dart';
export 'utils/extension/_extension.dart';
export 'utils/widgets/_widgets.dart';
export 'utils/color.dart';
export 'utils/constant.dart';
export 'utils/formatter.dart';
export 'utils/icons.dart';
export 'utils/padding.dart';
export 'utils/regexp.dart';
export 'utils/style.dart';
export 'utils/theme.dart';
export 'utils/utility.dart';

//* Package
export 'package:flutter_markdown/flutter_markdown.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:get/get.dart' hide HeaderValue, IterableExtensions, Node, VoidCallback, ListEquality, Worker;
export 'package:logger/logger.dart';
export 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
export 'package:shared_preferences/shared_preferences.dart';

import 'utils_platform_interface.dart';

class Utils {
  Future<String?> getPlatformVersion() {
    return UtilsPlatform.instance.getPlatformVersion();
  }
}
