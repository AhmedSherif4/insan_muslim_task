
import 'dart:math' as math;

import 'package:flutter/services.dart';


class TimeTextInputFormatter extends TextInputFormatter {
  final RegExp _exp = RegExp(r'^[0-9:]+$');

  TimeTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (_exp.hasMatch(newValue.text)) {
      TextSelection newSelection = newValue.selection;

      String value = newValue.text;
      String newText;

      String leftChunk = '';
      String rightChunk = '';

      if (value.length >= 5) {
        if (value.substring(0, 4) == '00:0') {
          leftChunk = '00:';
          rightChunk = value.substring(leftChunk.length + 1, value.length);
        } else if (value.substring(0, 3) == '00:') {
          leftChunk = '0';
          rightChunk = "${value.substring(3, 4)}:${value.substring(4)}";
        } else {
          leftChunk = '';
          rightChunk =
              "${value.substring(1, 2)}${value.substring(3, 4)}:${value.substring(4, 5)}${value.substring(5, 6)}";
        }
      }  else {
        leftChunk = '00:0';
        rightChunk = value;
      }

      if (oldValue.text.isNotEmpty && oldValue.text.substring(0, 1) != '0') {
        if (value.length > 4) {
          return oldValue;
        } else {
          leftChunk = '0';
          rightChunk =
              "${value.substring(0, 1)}:${value.substring(1, 2)}${value.substring(3, 4)}";
        }
      }

      newText = leftChunk + rightChunk;

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(newText.length, newText.length),
        extentOffset: math.min(newText.length, newText.length),
      );

      return TextEditingValue(
        text: newText,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return oldValue;
  }
}
