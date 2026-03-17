part of 'utility.dart';

int parseInt(dynamic value) {
  try {
    return value is int ? value : int.parse(value as String);
  } catch (_) {
    return 0;
  }
}
