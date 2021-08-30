import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final MaskTextInputFormatter zipCodeFormatter =
    MaskTextInputFormatter(mask: '##.###-###', filter: {'#': RegExp('[0-9]')});

final MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##', filter: {'#': RegExp('[0-9]')});

final MaskTextInputFormatter cnpjFormatter = MaskTextInputFormatter(
    mask: '##.###.###/####-##', filter: {'#': RegExp('[0-9]')});

class MaskTextInputFormatter implements TextInputFormatter {
  String? _mask;
  late List<String> _maskChars;
  Map<String, RegExp>? _maskFilter;

  int _maskLength = 0;
  final _TextMatcher _resultTextArray = _TextMatcher();
  String _resultTextMasked = '';

  TextEditingValue? _lastResValue;
  TextEditingValue? _lastNewValue;

  MaskTextInputFormatter(
      {required String? mask,
      Map<String, RegExp>? filter,
      String? initialText}) {
    updateMask(
        mask: mask,
        filter: filter ?? {'#': RegExp('[0-9]'), 'A': RegExp('[^0-9]')});
    if (initialText != null) {
      formatEditUpdate(
          const TextEditingValue(), TextEditingValue(text: initialText));
    }
  }

  TextEditingValue updateMask({String? mask, Map<String, RegExp>? filter}) {
    _mask = mask;
    if (filter != null) {
      _updateFilter(filter);
    }
    _calcMaskLength();
    final unmaskedText = getUnmaskedText();
    clear();
    return formatEditUpdate(
        const TextEditingValue(),
        TextEditingValue(
            text: unmaskedText,
            selection: TextSelection.collapsed(offset: unmaskedText.length)));
  }

  String? getMask() => _mask;

  String getMaskedText() => _resultTextMasked;

  String getUnmaskedText() => _resultTextArray.toString();

  bool isFill() => _resultTextArray.length == _maskLength;

  void clear() {
    _resultTextMasked = '';
    _resultTextArray.clear();
    _lastResValue = null;
    _lastNewValue = null;
  }

  String maskText(String text) => MaskTextInputFormatter(
          mask: _mask, filter: _maskFilter, initialText: text)
      .getMaskedText();

  String unmaskText(String text) => MaskTextInputFormatter(
          mask: _mask, filter: _maskFilter, initialText: text)
      .getUnmaskedText();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (_lastResValue == oldValue && newValue == _lastNewValue) {
      return _lastResValue!;
    }
    _lastNewValue = newValue;
    return _lastResValue = _format(oldValue, newValue);
  }

  TextEditingValue _format(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (_mask == null || _mask!.isEmpty) {
      _resultTextMasked = newValue.text;
      _resultTextArray.set(newValue.text);
      return newValue;
    }

    final beforeText = oldValue.text;
    final afterText = newValue.text;

    final beforeSelection = oldValue.selection;
    final beforeSelectionStart =
        beforeSelection.isValid ? beforeSelection.start : 0;
    final beforeSelectionLength = beforeSelection.isValid
        ? beforeSelection.end - beforeSelection.start
        : 0;

    final lengthDifference =
        afterText.length - (beforeText.length - beforeSelectionLength);
    final lengthRemoved = lengthDifference < 0 ? lengthDifference.abs() : 0;
    final lengthAdded = lengthDifference > 0 ? lengthDifference : 0;

    final afterChangeStart = max(0, beforeSelectionStart - lengthRemoved);
    final afterChangeEnd = max(0, afterChangeStart + lengthAdded);

    final beforeReplaceStart = max(0, beforeSelectionStart - lengthRemoved);
    final beforeReplaceLength = beforeSelectionLength + lengthRemoved;
    final beforeResultTextLength = _resultTextArray.length;

    var currentResultTextLength = _resultTextArray.length;
    var currentResultSelectionStart = 0;
    var currentResultSelectionLength = 0;

    for (var i = 0;
        i < min(beforeReplaceStart + beforeReplaceLength, _mask!.length);
        i++) {
      if (_maskChars.contains(_mask![i]) && currentResultTextLength > 0) {
        currentResultTextLength -= 1;
        if (i < beforeReplaceStart) {
          currentResultSelectionStart += 1;
        }
        if (i >= beforeReplaceStart) {
          currentResultSelectionLength += 1;
        }
      }
    }

    final replacementText =
        afterText.substring(afterChangeStart, afterChangeEnd);
    var targetCursorPosition = currentResultSelectionStart;
    if (replacementText.isEmpty) {
      _resultTextArray.removeRange(currentResultSelectionStart,
          currentResultSelectionStart + currentResultSelectionLength);
    } else {
      if (currentResultSelectionLength > 0) {
        _resultTextArray.removeRange(currentResultSelectionStart,
            currentResultSelectionStart + currentResultSelectionLength);
      }
      _resultTextArray.insert(currentResultSelectionStart, replacementText);
      targetCursorPosition += replacementText.length;
    }

    if (beforeResultTextLength == 0 && _resultTextArray.length > 1) {
      for (var i = 0; i < _mask!.length; i++) {
        if (_maskChars.contains(_mask![i]) || _resultTextArray.isEmpty) {
          break;
        } else if (_mask![i] == _resultTextArray[0]) {
          _resultTextArray.removeAt(0);
        }
      }
    }

    var curTextPos = 0;
    var maskPos = 0;
    _resultTextMasked = '';
    var cursorPos = -1;
    var nonMaskedCount = 0;

    while (maskPos < _mask!.length) {
      final curMaskChar = _mask![maskPos];
      final isMaskChar = _maskChars.contains(curMaskChar);

      var curTextInRange = curTextPos < _resultTextArray.length;

      String? curTextChar;
      if (isMaskChar && curTextInRange) {
        while (curTextChar == null && curTextInRange) {
          final potentialTextChar = _resultTextArray[curTextPos];
          if (_maskFilter![curMaskChar]!.hasMatch(potentialTextChar)) {
            curTextChar = potentialTextChar;
          } else {
            _resultTextArray.removeAt(curTextPos);
            curTextInRange = curTextPos < _resultTextArray.length;
            if (curTextPos <= targetCursorPosition) {
              targetCursorPosition -= 1;
            }
          }
        }
      }

      if (isMaskChar && curTextInRange) {
        _resultTextMasked += curTextChar!;
        if (curTextPos == targetCursorPosition && cursorPos == -1) {
          cursorPos = maskPos - nonMaskedCount;
        }
        nonMaskedCount = 0;
        curTextPos += 1;
      } else {
        if (curTextPos == targetCursorPosition &&
            cursorPos == -1 &&
            !curTextInRange) {
          cursorPos = maskPos;
        }

        if (!curTextInRange) {
          break;
        } else {
          _resultTextMasked += _mask![maskPos];
        }

        nonMaskedCount++;
      }

      maskPos += 1;
    }

    if (nonMaskedCount > 0) {
      _resultTextMasked = _resultTextMasked.substring(
          0, _resultTextMasked.length - nonMaskedCount);
      cursorPos -= nonMaskedCount;
    }

    if (_resultTextArray.length > _maskLength) {
      _resultTextArray.removeRange(_maskLength, _resultTextArray.length);
    }

    final finalCursorPosition =
        cursorPos < 0 ? _resultTextMasked.length : cursorPos;

    return TextEditingValue(
        text: _resultTextMasked,
        selection: TextSelection(
            baseOffset: finalCursorPosition,
            extentOffset: finalCursorPosition,
            affinity: newValue.selection.affinity,
            isDirectional: newValue.selection.isDirectional));
  }

  void _calcMaskLength() {
    _maskLength = 0;
    if (_mask != null) {
      for (var i = 0; i < _mask!.length; i++) {
        if (_maskChars.contains(_mask![i])) {
          _maskLength++;
        }
      }
    }
  }

  void _updateFilter(Map<String, RegExp> filter) {
    _maskFilter = filter;
    _maskChars = _maskFilter?.keys.toList(growable: false) ?? [];
  }
}

class _TextMatcher {
  final List<String> _symbolArray = <String>[];

  int get length => _symbolArray.fold(0, (prev, match) => prev + match.length);

  void removeRange(int start, int end) => _symbolArray.removeRange(start, end);

  void insert(int start, String substring) {
    for (var i = 0; i < substring.length; i++) {
      _symbolArray.insert(start + i, substring[i]);
    }
  }

  bool get isEmpty => _symbolArray.isEmpty;

  void removeAt(int index) => _symbolArray.removeAt(index);

  String operator [](int index) => _symbolArray[index];

  void clear() => _symbolArray.clear();

  @override
  String toString() => _symbolArray.join();

  void set(String text) {
    _symbolArray.clear();
    for (var i = 0; i < text.length; i++) {
      _symbolArray.add(text[i]);
    }
  }
}
