import 'package:intl/intl.dart';

/// 기준 : 2021년 4월 17일 오후 3시 55분 20초
/// value.toFormatString('y') // '2021년'
/// value.toFormatString('yMMMM') // '2021년 4월'
/// value.toFormatString('yMMMMd') // '2021년 4월 17일'
/// value.toFormatString('yMMMMEEEEd') // '2021년 4월 17일 토요일'
/// value.toFormatString('yMMMMEEEEd a hh:mm') // '2021년 4월 17일 토요일 오후 3:55
/// value.toFormatString('yMMMMEEEd a hh:mm') // '2021년 4월 17일 토 오후 3:55
/// value.toFormatString('yMMMMEEEEd HH:mm') // '2021년 4월 17일 토요일 15:55'
///
/// value.toFormatString('yyyy-MM-DD') // '2021-04-17'
/// value.toFormatString('yyyy-MM') // '2021-04'
/// value.toFormatString('yyyy') // '2021'
/// value.toFormatString('HH:mm:ss') // '15:55:20'
/// value.toFormatString('HH:mm') // '15:55'
/// value.toFormatString('HH') // '15'
extension WtDateTime on DateTime {
  /// 오후 11:39 (result:11)
  String toHour() {
    return DateFormat('hh').format(toLocal());
  }

  /// 오후 11:39 (result:39)
  String toMinute() {
    return DateFormat('mm').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateTimeString(); // 2021년 4월 17일 오후 3:5
  /// ```
  String toFullDateTimeString() {
    return DateFormat('yyyy년 M월 d일 a hh:mm', 'ko').format(toLocal());
  }

  /// 상품용 날짜 포맷
  String toProductDateForm() {
    return DateFormat('yyyy.MM.dd (E)').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateTimeString2(); // 2021.04.26 11:39
  /// ```
  String toFullDateTimeString2() {
    return DateFormat('yyyy.MM.dd HH:mm').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateTimeString3(); // 2021.04.26 월요일 11:39
  /// ```
  String toFullDateTimeString3() {
    return DateFormat('yyyy.MM.dd EEEE HH:mm').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateTimeString4(); // 2021.04.26 AM 11:39
  /// ```
  String toFullDateTimeString4() {
    return DateFormat('yyyy.MM.dd  a hh:mm', 'en_US').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateTimeString5(); // 2021.04.26(월) 11:39
  /// ```
  String toFullDateTimeString5() {
    return DateFormat('yyyy.MM.dd(EEE) HH:mm').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateTimeString6(); // 2021.04.26 오전 11:39
  /// ```
  String toFullDateTimeString6() {
    return DateFormat('yyyy.MM.dd  a hh:mm', 'ko').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateTimeString5(); // 2021.04.26(월) 11:39
  /// ```
  String toFullDateTimeString7() {
    return DateFormat('yyyy.MM.dd(EEE) a hh:mm').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateString1(); // 2021년 4월 26일 월요일
  /// ```
  String toFullDateString1() {
    return DateFormat('yMMMMEEEEd').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateString2(); // 2021년 4월 26일
  /// ```
  String toFullDateString2() {
    return DateFormat('yMMMMd', 'ko').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateString3(); // 2021.04.26
  /// ```
  String toFullDateString3() {
    return DateFormat('yyyy.MM.dd').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toFullDateString3(); // 21.04.26
  /// ```
  String toFullDateString4() {
    return DateFormat('yy.MM.dd').format(toLocal());
  }

  String toFullDateCustom(String str) {
    return DateFormat('yyyy${str}MM${str}dd').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toDateString1(); // 4월 26일
  /// ```
  String toDateString1() {
    return DateFormat('MMMMd').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toDateString2(); // 04.26
  /// ```
  String toDateString2() {
    return DateFormat('MMdd').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toDateString3(); // 26
  /// ```
  String toDateString3() {
    return DateFormat('dd').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toDateYearString(); // 4월
  /// ```
  String toDateYearString() {
    return DateFormat('MMMM').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toDateYearString2(); // 04
  /// ```
  String toDateYearString2() {
    return DateFormat('MM').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toDateMonthString(); // 26일
  /// ```
  String toDateMonthString() {
    return DateFormat('d').format(toLocal());
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toDateMonthString2(); // 26
  /// ```
  String toDateMonthString2() {
    return DateFormat('dd').format(toLocal());
  }

  /// 시간 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toTimestampString1(); // 오전 11:39
  /// ```
  String toTimestampString1() {
    return DateFormat('jm').format(toLocal());
  }

  /// 시간 가변 포맷
  ///
  /// Example:
  /// ```dart
  /// 현재 시간과 비교해서 세 가지 포맷 중 하나로 출력합니다.
  ///
  /// value.toFormatString('yMMMM') // '2021년 4월'
  /// datetimeA.toDateString1(); // 4월 26일
  /// datetimeA.toTimestampString1(); // 오전 11:39
  /// ```
  String toVariationString1() {
    final now = DateTime.now().toLocal();
    if (isSameDate(now)) {
      return DateFormat('jm').format(toLocal());
    } else if (year == now.year) {
      return toDateString1();
    } else {
      return DateFormat('yMMMM').format(toLocal());
    }
  }

  bool equalDate(DateTime diff) {
    return DateTime(year, month, day).difference(DateTime(diff.year, diff.month, diff.day)).inDays == 0;
  }

  /// 시간 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toTimestampString2(); // 11:39
  /// ```
  String toTimestampString2() {
    return DateFormat('HH:mm').format(toLocal());
  }

  /// 날짜 비교
  ///
  /// Example:
  /// ```dart
  /// datetimeA.isSameDate(datetimeB); // true
  /// ```
  bool isSameDate([DateTime? other]) {
    other ??= DateTime.now().toLocal();
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns the [bool] wheather the given date are inside iterval or not.
  ///
  /// Example:
  /// ```dart
  /// DateTime(2000, 1, 2).isBetween(DateTime(2000, 1, 1), DateTime(2000, 1, 31)); // true
  /// DateTime(2000, 1, 1).isBetween(DateTime(2000, 1, 1), DateTime(2000, 1, 1)); // true
  /// ```
  bool isBetween(DateTime from, DateTime to) {
    return (isAfter(from) && isBefore(to)) || this == from || this == to;
  }

  // 날짜만 구할 때 사용합니다.
  DateTime get date => DateTime(year, month, day);

  // static int _serverNowMilliseconds = 0;
  // static int _serverInitUptime = 0;

  /// Wt서버의 현재 시간을 설정합니다.
  // static initTime(int serverNowMilliseconds) {
  //   _serverNowMilliseconds = serverNowMilliseconds;
  //   _serverInitUptime = SystemClock.elapsedRealtime().inMilliseconds;
  // }

  /// Wt서버의 현재 시간을 구해옵니다.
  // static DateTime now() {
  //   if (_serverNowMilliseconds == 0) {
  //     return DateTime.now();
  //   } else {
  //     return DateTime.fromMillisecondsSinceEpoch(
  //         SystemClock.elapsedRealtime().inMilliseconds - _serverInitUptime + _serverNowMilliseconds);
  //   }
  // }

  /// 시간 가변 포맷
  ///
  /// Example:
  /// ```dart
  /// 현재 시간과 비교해서 세 가지 포맷 중 하나로 출력합니다.
  ///
  /// value.toFormatString('yMMMM') // '2021년 4월'
  /// datetimeA.toDateString1(); // 4월 26일
  /// datetimeA.difference(toLocal()).inDays == 1 // '어제'
  /// datetimeA.toTimestampString1(); // 오전 11:39
  /// ```
  String toLastMessageDate() {
    final now = DateTime.now().toLocal();
    int differenceInDays(DateTime date) {
      return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
    }

    if (isSameDate(now)) {
      return DateFormat('jm').format(toLocal());
    } else if (differenceInDays(toLocal()) == -1) {
      return "어제";
    } else if (year == now.year) {
      return DateFormat('MMMMd').format(toLocal());
    } else {
      return DateFormat('yMMMM').format(toLocal());
    }
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toRecordDate(); // 4월 26일 화요일
  /// ```
  String toRecordDate() {
    final duration = DateTime.now().date.difference(date);
    if (duration.inDays == 0) {
      return DateFormat('오늘, EEEE', 'ko').format(this);
    } else if (duration.inDays == 1) {
      return DateFormat('어제, EEEE', 'ko').format(this);
    } else if (duration.inDays == 2) {
      return DateFormat('그저께, EEEE', 'ko').format(this);
    }
    return DateFormat('MMMMEEEEd', 'ko').format(this);
  }

  /// 날짜 포맷
  ///
  /// Example:
  /// ```dart
  /// datetimeA.toRecordTime(); // 방금 전, 3분 전, 4시간 전, 오후 11시
  /// ```
  String toRecordTime() {
    final now = DateTime.now();
    if (year == now.year && month == now.month && day == now.day) {
      final duration = DateTime.now().difference(this);
      if (duration.inHours <= 0) {
        if (duration.inMinutes <= 0) {
          return '방금 전';
        } else {
          return '${duration.inMinutes}분 전';
        }
      } else {
        return '${duration.inHours}시간 전';
      }
    } else {
      return DateFormat('a h시', 'ko').format(this);
    }
  }
}

extension WtDateTimeExtension on DateTime? {
  int compareTo(DateTime? other) {
    if (this == null) {
      return other == null ? 0 : -1;
    } else if (other == null) {
      return 1;
    } else {
      return this!.compareTo(other);
    }
  }
}
