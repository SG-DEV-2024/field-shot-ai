import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:utils/utils.dart';
import 'package:utils/utils/extension/_extension.dart';
import 'package:utils/utils/regexp.dart';

extension WtStringExtension2 on String? {
  /// 문자열 변환 시 데이터가 없는경우 초기값 제공
  ///
  /// Example:
  /// ```dart
  /// ''.toDefaultString(); // '-'
  /// null.toDefaultString(); // '-'
  /// '123'.toDefaultString(); // '123'
  /// ```
  String toDefaultString(String? defaultString) {
    if (this == null || this!.isEmpty) {
      return defaultString ?? '알 수 없음';
    } else {
      return toString();
    }
  }

  /// 화폐단위로 변환
  ///
  /// Example:
  /// ```dart
  /// '123456789'.toCurrency(); // '123,456,789'
  /// ```
  String toCurrency() {
    if (this == null) {
      return '';
    } else {
      int data = toString().replaceAll(',', '').toInt();
      return NumberFormat('###,###,###,###').format(data).replaceAll(' ', '');
    }
  }

  /// 생년월일 포맷 변환
  ///
  /// Example:
  /// ```dart
  /// '19921001'.toBirthday(); // '1992.10.01'
  /// ```
  String toBirthday() {
    if (this == null) return '';
    if (this!.length != 8) return this!;
    return '${this!.substring(0, 4)}.${this!.substring(4, 6)}.${this!.substring(6, 8)}';
  }

  // 월일
  String toDate() {
    if (this == null) return '';
    if (this!.length != 8) return this!;
    return '${this!.substring(4, 6)}.${this!.substring(6, 8)}';
  }

  /// 가격 포맷
  ///
  /// Example:
  /// ```dart
  /// ''.toPrice(); // '무료'
  /// '325'.toPrice(); // '325'
  /// ```
  String toPrice() {
    if (this == null) {
      return '';
    } else {
      return this!.isEmpty || this == '0' || this == '' ? '무료' : toCurrency();
    }
  }

  /// 가격 포맷2
  ///
  /// Example:
  /// ```dart
  /// ''.toPrice(); // '무료'
  /// '325'.toPrice(); // '325원'
  /// ```
  String toPrice2() {
    if (this == null) {
      return '';
    } else {
      return this!.isEmpty || this == '0' || this == '' ? '무료' : '${toCurrency()}원';
    }
  }

  /// 가격 포맷3
  ///
  /// Example:
  /// ```dart
  /// '5'.toPrice(prefix = '선물'); // '선물 5개'
  /// ```
  String toPrice3({String prefix = '', String suffix = '개'}) {
    if (this == null) {
      return '';
    } else {
      return '$prefix ${toCurrency()}$suffix';
    }
  }

  /// 가격 포맷4
  ///
  /// 천원단위로 변경 1,000,000 -> 1,000
  String toPrice4() {
    int data = toInt();
    return (data / 1000).toCurrency();
  }

  String toGender() {
    if (this == 'MALE') {
      return '남성';
    } else if (this == 'FEMALE') {
      return '여성';
    } else {
      return '';
    }
  }

  /// 전화번호 형식으로 변환
  ///
  /// Example:
  /// ```dart
  /// '01012344256'.toPhoneNumber(); // '010-1234-4256'
  /// ```
  String toPhoneNumber() {
    const List<String?> areaNumberList = [
      '02',
      '051',
      '053',
      '032',
      '062',
      '042',
      '052',
      '044',
      '031',
      '033',
      '043',
      '041',
      '063',
      '061',
      '054',
      '055',
      '064'
    ]; //지역번호
    const List<String?> oldNumberList = ['011', '012', '013', '014', '015', '016', '017', '018', '019']; //옛날번호
    const List<String?> internetNumberList = ['010', '070']; //인터넷

    if (this == null) return '';

    if (this!.isEmpty) {
      return '';
    }

    if (this!.contains('-')) return this!;

    if (this!.length < 3) {
      return this!;
    }
    if (this!.length >= 2 && areaNumberList.contains(this!.substring(0, 2))) {
      if (this!.length <= 6) {
        return '${this!.substring(0, 2)}-${this!.substring(2, this!.length)}';
      } else {
        return '${this!.substring(0, 2)}-${this!.substring(2, 6)}-${this!.substring(6, this!.length)}';
      }
    } else if (areaNumberList.contains(this!.substring(0, 3))) {
      if (this!.length <= 6) {
        return '${this!.substring(0, 3)}-${this!.substring(3, this!.length)}';
      } else {
        return '${this!.substring(0, 3)}-${this!.substring(3, 6)}-${this!.substring(6, this!.length)}';
      }
    } else if (oldNumberList.contains(this!.substring(0, 3))) {
      if (this!.length <= 6) {
        return '${this!.substring(0, 3)}-${this!.substring(3, this!.length)}';
      } else {
        return '${this!.substring(0, 3)}-${this!.substring(3, 7)}-${this!.substring(7, this!.length)}';
      }
    } else if (internetNumberList.contains(this!.substring(0, 3))) {
      if (this!.length <= 7) {
        return '${this!.substring(0, 3)}-${this!.substring(3, this!.length)}';
      } else {
        return '${this!.substring(0, 3)}-${this!.substring(3, 7)}-${this!.substring(7, this!.length)}';
      }
    } else {
      return this!;
    }
  }

  /// 사업자 등록번호 형식으로 변환
  ///
  /// Example:
  /// ```dart
  /// '0001122222'.toBusinessNumber() // '000-11-22222'
  /// ```
  String toBusinessNumber() {
    if (this == null) return '';
    if (this!.contains('-')) return this!;

    if (this!.length == 10 && this!.isNumericOnly) {
      return '${this!.substring(0, 3)}-${this!.substring(3, 5)}-${this!.substring(5, this!.length)}';
    } else {
      return this!;
    }
  }

  /// Parses string and returns integer value.
  ///
  /// You can set an optional [radix!] to specify the numeric base.
  /// If no [radix!] is set, it will use the decimal system (10).
  ///
  /// Returns `null` if parsing fails.
  ///
  /// Example:
  /// ```dart
  /// '2'.toInt();     // 2
  /// 'invalid'.toInt(); // 0
  /// '2invalid'.toInt(); // 0
  /// ```
  int toInt() {
    try {
      if (this == null) return 0;
      return int.parse(this!, radix: 10);
    } catch (error) {
      return 0;
    }
  }

  /// Parses string and returns digit list value.
  List<int> toDigits() {
    try {
      if (this == null) return [];
      final result = <int>[];
      final regEx = RegExp(r'(\d+)\D*');

      String input = this!;
      String? bit;
      while (true) {
        var match = regEx.firstMatch(input);
        if ((bit = match?.group(1)) != null) {
          final no = int.tryParse(bit!);
          if (no != null) result.add(no);
        } else {
          break;
        }
        input = input.substring(match?.end ?? input.length);
      }
      return result;
    } catch (error) {
      return [];
    }
  }

  /// Parses string and return double value.
  ///
  /// Returns `null` if parsing fails.
  ///
  /// Example:
  /// ```dart
  /// '2.1'.toDouble();     // 2.1
  /// 'invalid'.toDouble(); // 0
  /// ```
  double toDouble() {
    try {
      if (this == null) return 0;
      return double.parse(this!);
    } catch (error) {
      return 0;
    }
  }

  /// 접두사 추가
  ///
  /// 추가할 문자 중복 시 제거(deduplication = true로 사용)
  String toPrefixAppend(String appendData, {bool deduplication = false}) {
    try {
      if (this == null || this!.isEmpty) return '';

      if (deduplication) {
        return appendData + this!.replaceAll(appendData, '');
      } else {
        return appendData + this!;
      }
    } catch (error) {
      return '';
    }
  }

  /// 접미사 추가
  ///
  /// 추가할 문자 중복 시 제거(deduplication = true로 사용)
  String toSuffixAppend(String appendData, {bool deduplication = false}) {
    try {
      if (this == null || this!.isEmpty) return '';
      if (deduplication) {
        return this!.replaceAll(appendData, '') + appendData;
      } else {
        return this! + appendData;
      }
    } catch (error) {
      return '';
    }
  }

  String toStringOrEmpty() => this == null ? '' : this!.toString();

  /// Searches the string for the first occurrence of a [pattern] and returns
  /// everything after that occurrence.
  ///
  /// Returns `''` if no occurrences were found.
  ///
  /// Example:
  /// ```dart
  /// 'value=1'.allAfter('=');                 // '1'
  /// 'i like turtles'.allAfter('like')        // ' turtles'
  /// 'i   like cats'.allAfter(RegExp('\\s+')) // 'like cats'
  /// ```
  String allAfter(Pattern pattern) {
    if (this == null) return '';
    var matchIterator = pattern.allMatches(this!).iterator;

    if (matchIterator.moveNext()) {
      var match = matchIterator.current;
      var length = match.end - match.start;
      return this!.substring(match.start + length);
    }
    return '';
  }

  /// Searches the string for the last occurrence of a [pattern] and returns
  /// everything before that occurrence.
  ///
  /// Returns `''` if no occurrences were found.
  ///
  /// Example:
  /// ```dart
  /// 'value=1'.allBefore('=');          // 'value'
  /// 'i like turtles'.allBefore('like') // 'i '
  /// ```
  String allBefore(Pattern pattern) {
    if (this == null) return '';
    var matchIterator = pattern.allMatches(this!).iterator;

    Match? match;
    while (matchIterator.moveNext()) {
      match = matchIterator.current;
    }

    if (match != null) {
      return this!.substring(0, match.start);
    }
    return '';
  }

  /// Searches the string for the first occurrence of [startPattern] and the
  /// last occurrence of [endPattern]. It returns the string between that
  /// occurrences.
  ///
  /// Returns `''` if no occurrences were found.
  ///
  /// Example:
  /// ```dart
  /// 'i like turtles'.allBetween('i ', ' turtles') // 'like'
  /// ```
  String allBetween(Pattern startPattern, Pattern endPattern) {
    return allAfter(startPattern).allBefore(endPattern);
  }

  /// 정규식 확장

  /// 패스워드 확인
  bool get checkPassword {
    if (this == null) return false;
    return RegExp(RegExpPASSWORD).hasMatch(this!);
  }

  /// 사업자등록번호 확인
  bool get checkBRN {
    if (this == null) return false;
    return RegExp(RegExpBRN).hasMatch(this!);
  }

  /// 이메일 확인
  bool get checkEmail {
    if (this == null) return false;
    return RegExp(RegExpEMAIL).hasMatch(this!);
  }

  /// 휴대폰 번호 확인
  bool get checkPhoneNumber {
    if (this == null) return false;
    return RegExp(RegExpSMARTPHONE).hasMatch(this!);
  }

  /// URL 확인
  bool get checkUrl {
    if (this == null) return false;
    return RegExp(RegExpURL).hasMatch(this!);
  }

  /// 생년월일 확인(1900년생 이후)
  bool get checkBirthDay {
    if (this == null ||
        double.tryParse(toString().replaceAll('.', '')) == null ||
        this!.replaceAll('.', '').length != 8) return false;

    String data = this!.replaceAll('.', '');

    DateTime date = DateTime.parse(data);

    String y = date.year.toString().padLeft(4, '0');
    String m = date.month.toString().padLeft(2, '0');
    String d = date.day.toString().padLeft(2, '0');

    if (y.toInt() <= 1900) return false;

    final originalFormatString = '$y$m$d';

    return data == originalFormatString;
  }

  /// null이거나 empty인 경우 true
  bool get isNullEmpty => this == null || this!.isEmpty;

  /// null이 아니고 비어있지 않은 경우 true
  bool get isNotNullEmpty {
    if (this != null) {
      if (this != '') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  /// String postposition은 '은/는', '이/가', '을/를', '과/와', '으로/로'중 하나를 넣어줍니다.
  ///  - 이 중에 없는 것을 넣으면 '종성있음/종성없음' 으로 처리됩니다.
  String toPostposition(String postposition) {
    if (this == null || this!.isEmpty) return '';
    final splitted = postposition.split('/');
    if (splitted.length < 2) {
      throw ArgumentError('toPostposition 인자값에 오류가 생겼습니다.');
    }

    var last = this!.runes.last;
    if (_isKorean(last)) {
      bool result = ((last - 0xac00) ~/ (28 * 21)) < 0 ? false : (((last - 0xac00) % 28 != 0) ? true : false);
      return result ? this! + splitted[0] : this! + splitted[1];
    } else {
      return this! + splitted[1];
    }
  }

  bool _isKorean(int code) => (code >= 12593 && code <= 12643)
      ? true
      : (code >= 44032 && code <= 55203)
          ? true
          : false;

  /// toTag는 문자열을 태그값으로 변경합니다.
  String toTag() => hashCode.toString();

  int count(Pattern pattern) {
    if (this == null) {
      return 0;
    } else {
      int cnt = 0, start = -1;
      while (start < this!.length) {
        if ((start = this!.indexOf(pattern, start + 1)) >= 0) {
          cnt++; // 발견
        } else {
          break; // 발견 못함
        }
      }
      return cnt;
    }
  }

  int compareTo(String? other) {
    if (this == null) {
      return other == null ? 0 : -1;
    } else if (other == null) {
      return 1;
    } else {
      return this!.compareTo(other);
    }
  }

  // bool hasMatch(String pattern) => (this == null) ? false : RegExp(pattern).hasMatch(this!);

  // bool hasNumeric() => hasMatch(r'\d+');

  // bool hasAlphabet(String s) => hasMatch(r'[a-z]');

  // bool hasCapitalLetter(String s) => hasMatch(r'[A-Z]');
}

extension PartialSplit on String {
  /// A version of [String.split] that limits splitting to return a [List]
  /// of at most [count] items.
  ///
  /// [count] must be non-negative.  If [count] is 0, returns an empty
  /// [List].
  ///
  /// If splitting this [String] would result in more than [count] items,
  /// the final element will contain the unsplit remainder of this [String].
  ///
  /// If splitting this [String] would result in fewer than [count] items,
  /// returns a [List] with only the split substrings.
  List<String> partialSplit(Pattern pattern, int count) {
    assert(count >= 0);

    var result = <String>[];

    if (count == 0) {
      return result;
    }

    var offset = 0;
    var matches = pattern.allMatches(this);
    for (var match in matches) {
      if (result.length + 1 == count) {
        break;
      }

      if (match.end - match.start == 0 && match.start == offset) {
        continue;
      }

      result.add(substring(offset, match.start));
      offset = match.end;
    }
    result.add(substring(offset));
    return result;
  }
}
