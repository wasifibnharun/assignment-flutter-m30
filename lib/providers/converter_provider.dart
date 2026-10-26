import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../models/unit_category.dart';
import '../models/unit_item.dart';
import '../services/conversion_service.dart';

class ConverterProvider extends ChangeNotifier {
  ConverterProvider({ConversionService? service})
    : _service = service ?? const ConversionService() {
    _resetUnits();
    _recalculate();
  }

  final ConversionService _service;
  UnitCategory _selectedCategory = UnitCategory.length;
  late UnitItem _fromUnit;
  late UnitItem _toUnit;
  String _inputText = '25';
  double? _result;

  UnitCategory get selectedCategory => _selectedCategory;
  UnitItem get fromUnit => _fromUnit;
  UnitItem get toUnit => _toUnit;
  String get inputText => _inputText;
  double? get result => _result;
  List<UnitItem> get units => _service.unitsFor(_selectedCategory);
  String get formattedResult =>
      _result == null ? '—' : '${_format(_result!)} ${_toUnit.name}';
  String get resultHint => _result == null
      ? 'Enter a number to get started'
      : '${_format(double.parse(_inputText.trim()))} ${_fromUnit.name} equals';

  String get conversionNote {
    if (_fromUnit == _toUnit) return 'Same unit. Same value.';
    if (_selectedCategory == UnitCategory.temperature) {
      return _fromUnit.name == 'Celsius'
          ? '°F = (°C × 9/5) + 32'
          : '°C = (°F − 32) × 5/9';
    }
    final rate = _service.convert(1, _fromUnit, _toUnit);
    return '1 ${_fromUnit.name} = ${_format(rate)} ${_toUnit.name}';
  }

  void setCategory(UnitCategory category) {
    _selectedCategory = category;
    _resetUnits();
    _update();
  }

  void setFromUnit(UnitItem unit) {
    if (!units.contains(unit)) return;
    _fromUnit = unit;
    _update();
  }

  void setToUnit(UnitItem unit) {
    if (!units.contains(unit)) return;
    _toUnit = unit;
    _update();
  }

  void setInput(String text) {
    _inputText = text;
    _update();
  }

  void swapUnits() {
    final previous = _fromUnit;
    _fromUnit = _toUnit;
    _toUnit = previous;
    _update();
  }

  void _resetUnits() {
    _fromUnit = units[0];
    _toUnit = units[1];
  }

  void _update() {
    _recalculate();
    notifyListeners();
  }

  void _recalculate() {
    final value = double.tryParse(_inputText.trim());
    if (value == null || !value.isFinite) {
      _result = null;
      return;
    }
    final converted = _service.convert(value, _fromUnit, _toUnit);
    _result = converted.isFinite ? converted : null;
  }

  static String _format(double value) {
    final fixed = value.toStringAsFixed(AppConstants.decimalPlaces);
    if (double.tryParse(fixed) == 0) return '0';
    if (!fixed.contains('.') || fixed.contains('e')) return fixed;
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
