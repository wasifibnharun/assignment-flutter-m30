import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/models/unit_category.dart';
import 'package:unit_converter/providers/converter_provider.dart';
import 'package:unit_converter/services/conversion_service.dart';

void main() {
  late ConverterProvider state;
  setUp(() => state = ConverterProvider());
  tearDown(() => state.dispose());

  test('input and swap recalculate and strip trailing zeros', () {
    state.setInput('10');
    state.swapUnits();
    expect(state.formattedResult, '10000 Meter');
  });
  test('temperature rounds to four decimal places', () {
    state.setCategory(UnitCategory.temperature);
    state.swapUnits();
    state.setInput('100');
    expect(state.formattedResult, '37.7778 Celsius');
  });
  test(
    'empty, partial, invalid, non-finite and overflowing values are safe',
    () {
      for (final input in [
        '',
        '-',
        '.',
        '-.',
        'abc',
        'NaN',
        'Infinity',
        '1e999',
      ]) {
        state.setInput(input);
        expect(state.result, isNull, reason: input);
        expect(state.formattedResult, '—');
      }
      state.swapUnits();
      state.setInput('1e308');
      expect(state.result, isNull);
    },
  );
  test('negative zero displays as zero', () {
    state.setInput('-0.00001');
    expect(state.formattedResult, '0 Kilometer');
  });
  test('category changes reset units and retain input', () {
    state.setInput('2500');
    state.setCategory(UnitCategory.weight);
    expect(state.fromUnit.name, 'Gram');
    expect(state.toUnit.name, 'Kilogram');
    expect(state.inputText, '2500');
    expect(state.formattedResult, '2.5 Kilogram');
  });
  test('foreign units cannot be assigned to either dropdown', () {
    final foreign = const ConversionService().unitsFor(UnitCategory.weight)[0];
    state.setFromUnit(foreign);
    state.setToUnit(foreign);
    expect(state.fromUnit.category, UnitCategory.length);
    expect(state.toUnit.category, UnitCategory.length);
  });
  test(
    'same-unit selections and individual changes notify and recalculate',
    () {
      var notifications = 0;
      state.addListener(() => notifications++);
      state.setToUnit(state.fromUnit);
      expect(state.formattedResult, '25 Meter');
      state.setFromUnit(state.units[1]);
      expect(state.formattedResult, '25000 Meter');
      expect(notifications, 2);
    },
  );
}
