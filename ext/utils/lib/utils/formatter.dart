import 'package:utils/utils.dart';

bool _isDigit(String ch) => ch.compareTo('0') >= 0 && ch.compareTo('9') <= 0;

///TextInputFormatter 관련 클래스
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var oldText = oldValue.text;
    var newText = newValue.text;
    var selectionIndex = newValue.selection.end;

    // '-'이 삭제될 시 앞에 한문자를 더 삭제합니다.
    if (oldText.length > newText.length && oldValue.composing == TextRange.empty) {
      if (oldText.length > selectionIndex && oldText[selectionIndex] == '-') {
        if (selectionIndex > 0 && _isDigit(newText[selectionIndex - 1])) {
          newText = newText.substring(0, selectionIndex - 1) + newText.substring(selectionIndex, newText.length);
          selectionIndex--;
        }
      }
    }

    // replaceAll을 해줍니다. selectionIndex값 때문에 for loop로 해줍니다.
    String text = '';
    for (var i = newText.length - 1; i >= 0; i--) {
      // 역순 for loop로 해야 selectionIndex--문이 다음번에 i < selectionIndex에 영향을 미치지 않습니다.
      if (_isDigit(newText[i])) {
        text = newText[i] + text;
      } else {
        if (i < selectionIndex) selectionIndex--;
      }
    }
    // 문자열 길이가 전화번호 길이만큼 잘라줍니다.
    if (text.startsWith('02') && text.length > 10) {
      text = text.substring(0, 10);
      if (selectionIndex > 10) selectionIndex = 10;
    }
    if (text.length > 11) {
      text = text.substring(0, 11);
      if (selectionIndex > 10) selectionIndex = 11;
    }

    // 조건부에 맞는 경우 자동 하이펀 추가
    if (text.length >= 3 && text.startsWith('010')) {
      // 지역번호(010, 070)
      if (text.length >= 7) {
        text = '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7, text.length)}';
      } else {
        text = '${text.substring(0, 3)}-${text.substring(3, text.length)}';
      }
      if (selectionIndex >= 7) {
        selectionIndex += 2;
      } else if (selectionIndex >= 3) {
        selectionIndex++;
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class BusinessNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var oldText = oldValue.text;
    var newText = newValue.text;
    var selectionIndex = newValue.selection.end;

    // '-'이 삭제될 시 앞에 한문자를 더 삭제합니다.
    if (oldText.length > newText.length && oldValue.composing == TextRange.empty) {
      if (oldText.length > selectionIndex && oldText[selectionIndex] == '-') {
        if (selectionIndex > 0 && _isDigit(newText[selectionIndex - 1])) {
          newText = newText.substring(0, selectionIndex - 1) + newText.substring(selectionIndex, newText.length);
          selectionIndex--;
        }
      }
    }

    // replaceAll을 해줍니다. selectionIndex값 때문에 for loop로 해줍니다.
    String text = '';
    for (var i = newText.length - 1; i >= 0; i--) {
      // 역순 for loop로 해야 selectionIndex--문이 다음번에 i < selectionIndex에 영향을 미치지 않습니다.
      if (_isDigit(newText[i])) {
        text = newText[i] + text;
      } else {
        if (i < selectionIndex) selectionIndex--;
      }
    }
    // 문자열 길이가 사업자등록번호 길이만큼 잘라줍니다.
    if (text.length > 10) {
      text = text.substring(0, 10);
      if (selectionIndex > 10) selectionIndex = 10;
    }

    // 조건부에 맞는 경우 자동 하이펀 추가
    if (text.length >= 3) {
      if (text.length >= 5) {
        text = '${text.substring(0, 3)}-${text.substring(3, 5)}-${text.substring(5, text.length)}';
      } else {
        text = '${text.substring(0, 3)}-${text.substring(3, text.length)}';
      }
      if (selectionIndex >= 5) {
        selectionIndex += 2;
      } else if (selectionIndex >= 3) {
        selectionIndex++;
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class AreaNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var oldText = oldValue.text;
    var newText = newValue.text;
    var selectionIndex = newValue.selection.end;

    // '-'이 삭제될 시 앞에 한문자를 더 삭제합니다.
    if (oldText.length > newText.length && oldValue.composing == TextRange.empty) {
      if (oldText.length > selectionIndex && oldText[selectionIndex] == '-') {
        if (selectionIndex > 0 && _isDigit(newText[selectionIndex - 1])) {
          newText = newText.substring(0, selectionIndex - 1) + newText.substring(selectionIndex, newText.length);
          selectionIndex--;
        }
      }
    }

    // replaceAll을 해줍니다. selectionIndex값 때문에 for loop로 해줍니다.
    String text = '';
    for (var i = newText.length - 1; i >= 0; i--) {
      // 역순 for loop로 해야 selectionIndex--문이 다음번에 i < selectionIndex에 영향을 미치지 않습니다.
      if (_isDigit(newText[i])) {
        text = newText[i] + text;
      } else {
        if (i < selectionIndex) selectionIndex--;
      }
    }
    // 문자열 길이가 전화번호 길이만큼 잘라줍니다.
    if (text.startsWith('02') && text.length > 10) {
      text = text.substring(0, 10);
      if (selectionIndex > 10) selectionIndex = 10;
    }
    if (text.length > 11) {
      text = text.substring(0, 11);
      if (selectionIndex > 10) selectionIndex = 11;
    }

    // 조건부에 맞는 경우 자동 하이펀 추가
    if (text.length >= 2 && text.startsWith('02')) {
      // 지역번호(02)
      if (text.length >= 6) {
        text = '${text.substring(0, 2)}-${text.substring(2, 6)}-${text.substring(6, text.length)}';
      } else {
        text = '${text.substring(0, 2)}-${text.substring(2, text.length)}';
      }
      if (selectionIndex >= 6) {
        selectionIndex += 2;
      } else if (selectionIndex >= 2) {
        selectionIndex++;
      }
    } else if (text.length >= 3 && (text.startsWith('010') || text.startsWith('070'))) {
      // 지역번호(010, 070)
      if (text.length >= 7) {
        text = '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7, text.length)}';
      } else {
        text = '${text.substring(0, 3)}-${text.substring(3, text.length)}';
      }
      if (selectionIndex >= 7) {
        selectionIndex += 2;
      } else if (selectionIndex >= 3) {
        selectionIndex++;
      }
    } else if (text.length >= 3 && text.startsWith('0')) {
      // 나머지 지역번호
      if (text.length == 11) {
        text = '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7, 11)}';
        if (selectionIndex >= 7) {
          selectionIndex += 2;
        } else if (selectionIndex >= 3) {
          selectionIndex++;
        }
      } else {
        if (text.length >= 6) {
          text = '${text.substring(0, 3)}-${text.substring(3, 6)}-${text.substring(6, text.length)}';
        } else {
          text = '${text.substring(0, 3)}-${text.substring(3, text.length)}';
        }
        if (selectionIndex >= 6) {
          selectionIndex += 2;
        } else if (selectionIndex >= 3) {
          selectionIndex++;
        }
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class WtDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String oldText = oldValue.text;
    String newText = newValue.text;

    //점을 직접 입력하는경우 제어
    if (newText.length > oldText.length) {
      String lastNewText = newText.substring(newText.length - 1, newText.length);
      if (lastNewText == '.') {
        return TextEditingValue(
          text: oldText.toString(),
          selection: TextSelection.collapsed(offset: oldText.length),
        );
      }
    }

    if (newText == "") {
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    if (newText.length >= 11) {
      return TextEditingValue(
        text: oldText,
        selection: TextSelection.collapsed(offset: oldText.length),
      );
    }

    var regExp = RegExp(r'^[\d.]+$');

    if (!regExp.hasMatch(newText)) {
      return TextEditingValue(
        text: oldText.toString(),
        selection: TextSelection.collapsed(offset: oldText.length),
      );
    }

    if (oldText.length > newText.length) {
      if (newText.substring(newText.length - 1, newText.length) == '.') {
        newText = newText.substring(0, newText.length - 1);
      }
      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    if (newText.length == 5) {
      newText = "${newText.substring(0, newText.length - 1)}.${newText.substring(4, newText.length)}";
    }

    if (newText.length == 8) {
      newText = "${newText.substring(0, newText.length - 1)}.${newText.substring(7, newText.length)}";
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class SuffixTextFormatter extends TextInputFormatter {
  SuffixTextFormatter({required this.suffixText, int? space}) : space = space ?? 0;

  final String suffixText;
  final int space;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    //var oldText = oldValue.text;
    String newText = newValue.text.replaceAll(suffixText, '').replaceAll(" ", "");
    newText = newText.padRight(newText.length + space, " ");

    return TextEditingValue(
      text: '$newText${newText.isNotNullEmpty ? suffixText : ''}',
      selection: TextSelection.collapsed(offset: newText.trim().length),
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final double min;
  final double max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return newValue;
    } else if (int.parse(newValue.text) < min) {
      return const TextEditingValue().copyWith(text: min.toStringAsFixed(2));
    } else {
      return int.parse(newValue.text) > max ? oldValue : newValue;
    }
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') {
      return const TextEditingValue();
    } else {
      print('22');
      return int.parse(newValue.text) > oneMillion ? oldValue : newValue;
    }
  }
}
