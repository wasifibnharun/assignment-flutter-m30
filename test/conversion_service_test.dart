import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/models/unit_category.dart';
import 'package:unit_converter/services/conversion_service.dart';

void main() {
  const service = ConversionService();
  final length = service.unitsFor(UnitCategory.length);
  final weight = service.unitsFor(UnitCategory.weight);
  final temperature = service.unitsFor(UnitCategory.temperature);

  test('10 km → 10000 m', () {
    expect(service.convert(10, length[1], length[0]), 10000);
  });
  test('5000 m → 5 km', () {
    expect(service.convert(5000, length[0], length[1]), 5);
  });
  test('2500 g → 2.5 kg', () {
    expect(service.convert(2500, weight[0], weight[1]), 2.5);
  });
  test('3 kg → 3000 g', () {
    expect(service.convert(3, weight[1], weight[0]), 3000);
  });
  test('0 °C → 32 °F', () {
    expect(service.convert(0, temperature[0], temperature[1]), 32);
  });
  test('100 °C → 212 °F', () {
    expect(service.convert(100, temperature[0], temperature[1]), 212);
  });
  test('32 °F → 0 °C', () {
    expect(service.convert(32, temperature[1], temperature[0]), 0);
  });
  test('-40 °C ↔ -40 °F', () {
    expect(service.convert(-40, temperature[0], temperature[1]), -40);
    expect(service.convert(-40, temperature[1], temperature[0]), -40);
  });
  test('same unit preserves the value for every supported unit', () {
    for (final category in UnitCategory.values) {
      for (final unit in service.unitsFor(category)) {
        expect(service.convert(-12.345, unit, unit), -12.345);
      }
    }
  });
  test('cross-category conversions are rejected', () {
    expect(() => service.convert(1, length[0], weight[0]), throwsArgumentError);
  });
}
