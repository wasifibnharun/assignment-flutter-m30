import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../models/unit_item.dart';
import '../providers/converter_provider.dart';

class UnitDropdown extends StatelessWidget {
  const UnitDropdown({super.key, required this.isFrom});

  final bool isFrom;

  @override
  Widget build(BuildContext context) {
    final selection = context
        .select<ConverterProvider, (UnitItem, List<UnitItem>)>(
          (state) => (isFrom ? state.fromUnit : state.toUnit, state.units),
        );
    final label = isFrom ? 'From' : 'To';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.muted),
        ),
        const SizedBox(height: 9),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF101016),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2734)),
          ),
          child: Semantics(
            label: '$label unit',
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UnitItem>(
                key: Key(isFrom ? 'from-unit' : 'to-unit'),
                value: selection.$1,
                isExpanded: true,
                itemHeight: 52,
                dropdownColor: const Color(0xFF211E2C),
                borderRadius: BorderRadius.circular(14),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppTheme.muted,
                ),
                focusColor: AppTheme.accent.withValues(alpha: 0.08),
                style: Theme.of(context).textTheme.bodyMedium,
                items: selection.$2.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Row(
                      children: [
                        Expanded(child: Text(unit.name)),
                        Text(
                          unit.symbol,
                          style: const TextStyle(
                            color: AppTheme.muted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (unit) {
                  if (unit == null) return;
                  final state = context.read<ConverterProvider>();
                  if (isFrom) {
                    state.setFromUnit(unit);
                  } else {
                    state.setToUnit(unit);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
