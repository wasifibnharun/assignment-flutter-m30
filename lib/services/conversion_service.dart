import '../models/unit_category.dart';
import '../models/unit_item.dart';

/// Pure Dart conversion rules; no UI or state dependencies.
class ConversionService {
  const ConversionService();

  List<UnitItem> unitsFor(UnitCategory category) => switch (category) {
    UnitCategory.length => const [
      UnitItem(name: 'Meter', symbol: 'm', category: UnitCategory.length),
      UnitItem(name: 'Kilometer', symbol: 'km', category: UnitCategory.length),
    ],
    UnitCategory.weight => const [
      UnitItem(name: 'Gram', symbol: 'g', category: UnitCategory.weight),
      UnitItem(name: 'Kilogram', symbol: 'kg', category: UnitCategory.weight),
    ],
    UnitCategory.temperature => const [
      UnitItem(
        name: 'Celsius',
        symbol: '°C',
        category: UnitCategory.temperature,
      ),
      UnitItem(
        name: 'Fahrenheit',
        symbol: '°F',
        category: UnitCategory.temperature,
      ),
    ],
  };

  double convert(double value, UnitItem from, UnitItem to) {
    if (from.category != to.category ||
        !unitsFor(from.category).contains(from) ||
        !unitsFor(to.category).contains(to)) {
      throw ArgumentError('Choose supported units from the same category.');
    }
    if (from == to) return value;

    return switch (from.category) {
      // A kilometer or kilogram contains 1,000 base units.
      UnitCategory.length || UnitCategory.weight =>
        from == unitsFor(from.category).first ? value / 1000 : value * 1000,
      // Temperature scales differ in both step size and origin.
      UnitCategory.temperature =>
        from.name == 'Celsius' ? (value * 9 / 5) + 32 : (value - 32) * 5 / 9,
    };
  }
}
