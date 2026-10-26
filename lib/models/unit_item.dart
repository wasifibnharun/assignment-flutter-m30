import 'unit_category.dart';

class UnitItem {
  const UnitItem({
    required this.name,
    required this.symbol,
    required this.category,
  });

  final String name;
  final String symbol;
  final UnitCategory category;

  @override
  bool operator ==(Object other) =>
      other is UnitItem &&
      name == other.name &&
      symbol == other.symbol &&
      category == other.category;

  @override
  int get hashCode => Object.hash(name, symbol, category);
}
