import 'dart:ui';
//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flet/flet.dart';

//////////////////////////////////////////////////////////////
//original code from awesome project
//https://github.com/TBR-Group-software/amount_input_formatter
//////////////////////////////////////////////////////////////
//import 'package:amount_input_formatter/src/number_formatter.dart';
class NumberFormatter {
  factory NumberFormatter({
    int integralLength = kIntegralLengthLimit,
    String groupSeparator = kComma,
    String decimalSeparator = kDot,
    int fractionalDigits = 3,
    int groupedDigits = 3,
    bool isEmptyAllowed = false,
    num? initialValue,
  }) {
    if (initialValue == null) {
      return NumberFormatter._(
        integralLength: integralLength,
        groupSeparator: groupSeparator,
        groupedDigits: groupedDigits,
        decimalSeparator: decimalSeparator,
        fractionalDigits: fractionalDigits,
        initialValue: 0,
        indexOfDot: -1,
        initialFormattedValue: kEmptyValue,
        isEmptyAllowed: isEmptyAllowed,
      );
    }

    final doubleParts = initialValue.toDouble().abs().toString().split(kDot);

    return NumberFormatter._(
      integralLength: integralLength,
      groupSeparator: groupSeparator,
      groupedDigits: groupedDigits,
      decimalSeparator: decimalSeparator,
      fractionalDigits: fractionalDigits,
      initialValue: initialValue.toDouble(),
      isEmptyAllowed: isEmptyAllowed,
      initialFormattedValue: '${_processIntegerPart(integerPart: doubleParts.first, thSeparator: groupSeparator, intSpDigits: groupedDigits)}${_processDecimalPart(decimalPart: doubleParts.last, ftlDigits: fractionalDigits, dcSeparator: decimalSeparator)}',
      indexOfDot: doubleParts.first.length,
      );
    }

    NumberFormatter._({
      required int integralLength,
      required String groupSeparator,
      required String decimalSeparator,
      required int fractionalDigits,
      required String initialFormattedValue,
      required double? initialValue,
      required int groupedDigits,
      required int indexOfDot,
      required bool isEmptyAllowed,
    })  : _isEmptyAllowed = isEmptyAllowed,
    _intLthLimiter = integralLength,
    _intSeparator = groupSeparator,
    _intSpDigits = groupedDigits,
    _dcSeparator = decimalSeparator,
    _ftlDigits = fractionalDigits,
    _formattedNum = initialFormattedValue,
    _numPattern = RegExp('[^0-9$decimalSeparator]'),
    _currentValue = initialValue ?? 0,
    _indexOfDot = indexOfDot;

    NumberFormatter.defaultSettings()
    : _intLthLimiter = kIntegralLengthLimit,
    _intSeparator = kComma,
    _dcSeparator = kDot,
    _ftlDigits = 3,
    _intSpDigits = 3,
    _formattedNum = kEmptyValue,
    _currentValue = 0,
    _indexOfDot = -1,
    _numPattern = RegExp('[^0-9$kDot]'),
    _isEmptyAllowed = false;

    static const lre = '\u202A';

    static const pdf = '\u202C';

    static const kComma = ',';

    static const kDot = '.';

    static const kIntegralLengthLimit = 24;

    static const kEmptyValue = '';

    static const kZeroValue = '0';

    int _intLthLimiter;

    String _intSeparator;

    int _intSpDigits;

    String _dcSeparator;

    int _ftlDigits;

    bool _isEmptyAllowed;

    String _formattedNum;
    RegExp _numPattern;
    double _currentValue;
    int _indexOfDot;
    double _previousValue = 0;

    int get intLthLimiter => _intLthLimiter;

    String get intSeparator => _intSeparator;

    int get intSpDigits => _intSpDigits;

    String get dcSeparator => _dcSeparator;

    int get ftlDigits => _ftlDigits;

    double get doubleValue => _doubleValue;

    double get previousValue => _previousValue;

    int get indexOfDot => _indexOfDot;

    String get formattedValue => _formattedNum;

    bool get isEmptyAllowed => _isEmptyAllowed;

    double get _doubleValue => _currentValue;

    String get ltrEnforcedValue => '$lre$formattedValue$pdf';

    set intLthLimiter(int value) {
      _intLthLimiter = value;

      processTextValue(textInput: _formattedNum);
    }

    set intSeparator(String value) {
      _intSeparator = value;

      processTextValue(textInput: _formattedNum);
    }

    set intSpDigits(int value) {
      _intSpDigits = value;

      processTextValue(textInput: _formattedNum);
    }

    set dcSeparator(String value) {
      _dcSeparator = value;

      processTextValue(textInput: _formattedNum);
    }

    set ftlDigits(int value) {
      _ftlDigits = value;

      processTextValue(textInput: _formattedNum);
    }

    set isEmptyAllowed(bool value) {
      _isEmptyAllowed = value;

      processTextValue(textInput: _formattedNum);
    }

    set _doubleValue(double value) {
      _previousValue = _currentValue;
      _currentValue = value;
    }

    static String _processIntegerPart({
      required String integerPart,
      required String thSeparator,
      required int intSpDigits,
    }) {
      if (integerPart.length < intSpDigits) return integerPart;

      final intBuffer = StringBuffer();
      for (var i = 1; i <= integerPart.length; i++) {
        intBuffer.write(integerPart[integerPart.length - i]);

        if (i % intSpDigits == 0 && i != integerPart.length) {
          intBuffer.write(thSeparator);
        }
      }

      return String.fromCharCodes(intBuffer.toString().codeUnits.reversed);
    }

    static String _processDecimalPart({
      required String decimalPart,
      required int ftlDigits,
      required String dcSeparator,
    }) {
      if (ftlDigits <= 0) return kEmptyValue;

      if (decimalPart.length > ftlDigits) {
        return '$dcSeparator${decimalPart.substring(0, ftlDigits)}';
      } else if (decimalPart.length == ftlDigits) {
        return '$dcSeparator$decimalPart';
      }

      return '$dcSeparator$decimalPart'
      '${kZeroValue * (ftlDigits - decimalPart.length)}';
    }

    String _processNumberValue({
      double? inputNumber,
      List<String>? doubleParts,
    }) {
      if (inputNumber == null) {
        _doubleValue = 0;
        return _formattedNum = kEmptyValue;
      }

      _doubleValue = inputNumber;
      doubleParts ??= inputNumber.abs().toString().split(kDot);

      _indexOfDot = doubleParts.first.length;

      return _formattedNum = '${_processIntegerPart(integerPart: doubleParts.first, thSeparator: intSeparator, intSpDigits: intSpDigits)}${_processDecimalPart(decimalPart: doubleParts.last, ftlDigits: ftlDigits, dcSeparator: dcSeparator)}';
    }

    String _processEmptyValue({
      required String textInput,
      required bool isEmptyAllowed,
    }) {
      _doubleValue = 0;

      if (isEmptyAllowed) {
        _indexOfDot = -1;
        return _formattedNum = kEmptyValue;
      }

      _indexOfDot = 1;
      return _formattedNum = "$kZeroValue${_ftlDigits > 0 ? _dcSeparator : ''}${kZeroValue * _ftlDigits}";
    }

    String? processTextValue({
      required String textInput,
    }) {
      if (textInput.isEmpty) {
        return _processEmptyValue(textInput: textInput, isEmptyAllowed: isEmptyAllowed);
      }

      final List<String> doubleParts;
      if(dcSeparator.allMatches(textInput).length > 1)
      {
        final last_index_sep = textInput.lastIndexOf(dcSeparator);
        if(textInput.length - last_index_sep > _intSpDigits)
          doubleParts = textInput.replaceFirst(dcSeparator, kEmptyValue).replaceAll(_numPattern, kEmptyValue).split(dcSeparator);
        else
          doubleParts = textInput.replaceFirst(dcSeparator, kEmptyValue, last_index_sep).replaceAll(_numPattern, kEmptyValue).split(dcSeparator);
      }
      else
        doubleParts = textInput.replaceAll(_numPattern, kEmptyValue).split(dcSeparator);

      if (doubleParts.length == 1) {
        doubleParts.add(kEmptyValue);

        if (ftlDigits > 0 &&
          _indexOfDot > 0 &&
          _indexOfDot < doubleParts.first.length) {
          doubleParts.first = doubleParts.first.substring(0, _indexOfDot);
          }
      } else if (doubleParts.last.length > ftlDigits) {
        doubleParts.last = doubleParts.last.substring(0, ftlDigits);
      }

      if (doubleParts.first.length > intLthLimiter)
      {
        return null;
      }

      if (doubleParts.first.isEmpty) {
        doubleParts.first = kZeroValue;
      } else if (doubleParts.first[0] == kZeroValue &&
        doubleParts.first.length > 1) {
        var index = -1;

        for (var i = 0; i < doubleParts.first.length; i++) {
          if (doubleParts.first[i] != kZeroValue) break;

          index = i;
        }

        if (index == doubleParts.first.length - 1) index -= 1;

        if (index >= 0) {
          doubleParts.first = doubleParts.first.substring(index + 1);
        }
      }

      return _processNumberValue(
        inputNumber: double.tryParse('${doubleParts.first}$kDot${doubleParts.last}'),
        doubleParts: doubleParts
      );
    }

    String setNumValue(num number) => _processNumberValue(
      inputNumber: number.toDouble(),
    );

    String clear() {
      return _processEmptyValue(
        textInput: '',
        isEmptyAllowed: true,
      );
    }
}

//////////////////////////////////////////////////////////////////////
//import 'package:amount_input_formatter/amount_input_formatter.dart';
//////////////////////////////////////////////////////////////////////
class AmountInputFormatter extends TextInputFormatter {
  factory AmountInputFormatter({
    int integralLength = NumberFormatter.kIntegralLengthLimit,
    String groupSeparator = NumberFormatter.kComma,
    String decimalSeparator = NumberFormatter.kDot,
    int groupedDigits = 3,
    int fractionalDigits = 3,
    bool isEmptyAllowed = false,
    num? initialValue,
  }) {
    return AmountInputFormatter.withFormatter(
      formatter: NumberFormatter(
        initialValue: initialValue,
        integralLength: integralLength,
        groupSeparator: groupSeparator,
        groupedDigits: groupedDigits,
        decimalSeparator: decimalSeparator,
        fractionalDigits: fractionalDigits,
        isEmptyAllowed: isEmptyAllowed,
      ),
    );
  }

  const AmountInputFormatter.withFormatter({
    required this.formatter,
  });

  final NumberFormatter formatter;

  double get doubleValue => formatter.doubleValue;

  String get formattedValue => formatter.formattedValue;

  String get ltrEnforcedValue => formatter.ltrEnforcedValue;

  bool get isEmptyAllowed => formatter.isEmptyAllowed;

  int _calculateSelectionOffset({
    required TextEditingValue oldValue,
    required TextEditingValue newValue,
    required String newText,
  }) {
    if (oldValue.selection.baseOffset <= 1 && formatter.doubleValue <= 9) {
      if (newText.isEmpty) return 0;

      if (formatter.doubleValue == 0) {
        if (formatter.previousValue == 0 &&
          formatter.ftlDigits > 0 &&
            (newValue.selection.baseOffset > 1 || oldValue.text.isEmpty)) {
          return formatter.indexOfDot + 1;
            }

            return formatter.indexOfDot;
      }
    }

    if (oldValue.selection.baseOffset <= 1 &&
      formatter.doubleValue <= 9 &&
        formatter.previousValue <= 9) {
      return formatter.indexOfDot;
        }

        if (oldValue.text.length == newText.length) {
          final oldSelection = oldValue.selection;
          final newSelection = newValue.selection;

          if (newSelection.baseOffset > oldSelection.baseOffset) {
            return newSelection.baseOffset > newText.length
            ? newText.length
            : newSelection.baseOffset;
          }

          return newSelection.baseOffset;
        }

        var offset = 0;

        if (newText.length < oldValue.text.length) {
          offset = oldValue.text.length - newText.length > 1
          ? oldValue.selection.baseOffset -
          (oldValue.text.length - newText.length)
          : oldValue.selection.baseOffset - 1;
          return offset < 0 ? 0 : offset;
        }

        offset = newText.length - oldValue.text.length > 1
        ? oldValue.selection.baseOffset +
        (newText.length - oldValue.text.length)
        : oldValue.selection.baseOffset + 1;

        return offset > newText.length ? newText.length - 1 : offset;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = formatter.processTextValue(
      textInput: newValue.text,
    );

    if (newText == null) return oldValue;

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: _calculateSelectionOffset(
          oldValue: oldValue,
          newValue: newValue,
          newText: newText,
        ),
      ),
    );
  }

  String setNumber(
    num number, {
      TextEditingController? attachedController,
    }) {
    if (attachedController == null) return formatter.setNumValue(number);

    attachedController.value = TextEditingValue(
      text: formatter.setNumValue(number),
      selection: TextSelection.collapsed(offset: formatter.indexOfDot),
    );

    return attachedController.text;
    }

    String clear() => formatter.clear();
}

//////////////////////////////////////////////////////////////////////////
//import 'package:amount_input_formatter/text_controller_extension.dart';
//////////////////////////////////////////////////////////////////////////
extension FormatterTextControllerExtension on TextEditingController {
  String setAndFormatText({
    required String text,
    required AmountInputFormatter formatter,
    TextEditingValue? oldValue,
  }) {
    value = formatter.formatEditUpdate(
      oldValue ?? value,
      TextEditingValue(text: text),
    );

    return this.text;
  }

  String syncWithFormatter({required AmountInputFormatter formatter}) {
    value = TextEditingValue(
      text: formatter.formattedValue,
      selection: TextSelection.collapsed(
        offset: formatter.formatter.indexOfDot,
      ),
    );

    return text;
  }
}

//////////////////////////////////////////////////////
///////////////code for flet control//////////////////
//////////////////////////////////////////////////////
class FletDecimalInputControl extends StatelessWidget {
  final Control? parent;
  final Control control;
  //final FletControlBackend backend;
  double value = 0.0;

  FletDecimalInputControl({
    super.key,
    required this.parent,
    required this.control,
    //required this.backend
  });

  @override
  Widget build(BuildContext context) {
    this.value = control.attrDouble("value", 0.0)!;
    String sepd = control.attrString("separator_decimal", ".")!;
    String sepg = control.attrString("separator_group", " ")!;
    int ilen = control.attrInt("integral_length", NumberFormatter.kIntegralLengthLimit)!;
    int dgtsf = control.attrInt("digits_fractional", 3)!;
    int dgtsg = control.attrInt("digits_grouped", 3)!;
    bool isempty = control.attrBool("empty_allowed", false)!;
    TextAlign text_align = parseTextAlign(control.attrString("text_align", "left"), TextAlign.start)!;
    final AmountInputFormatter _formatter = AmountInputFormatter(
      initialValue: this.value,
      decimalSeparator: sepd,
      groupSeparator: sepg,
      integralLength: ilen,
      fractionalDigits: dgtsf,
      groupedDigits: dgtsg,
      isEmptyAllowed: isempty,
    );
    final TextEditingController _controller = TextEditingController();
    _controller.syncWithFormatter(formatter: _formatter);
    Widget child = TextField(
      controller: _controller,
      inputFormatters: [_formatter],
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      onSubmitted: (text) {},
      onTapOutside: (_) {},
      onChanged: (text) {
        //debugPrint('Text value: $text');
        //debugPrint('Double value: ${_formatter.doubleValue}');
        //backend.triggerControlEvent(control.id, "OnChanged", json.encode({'value':_formatter.doubleValue}));
        this.value = _formatter.doubleValue;
      },
      textAlign: text_align
    );
    //backend.updateControlState(control.id, {'child_id':child.toStringShort()});
    //backend.updateControlState(control.id, {'child_key':child.key.toString()});
    //backend.updateControlState(control.id, {'child_type':child.runtimeType.toString()});
    return constrainedControl(context, child, parent, control);
  }
}
