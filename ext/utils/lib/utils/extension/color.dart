import 'package:flutter/material.dart';

extension WtColorExtension on Color? {
  MaterialStateProperty<Color?>? toMaterialStateProperty() {
    return MaterialStateProperty.all<Color?>(this);
  }

  Color? withWhite(double t) => Color.lerp(this, Colors.white, t);
}
