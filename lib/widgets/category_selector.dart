import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../models/unit_category.dart';
import '../providers/converter_provider.dart';

extension UnitCategoryIcon on UnitCategory {
  IconData get icon => switch (this) {
    UnitCategory.length => Icons.straighten_rounded,
    UnitCategory.weight => Icons.scale_outlined,
    UnitCategory.temperature => Icons.thermostat_rounded,
  };
}

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.select<ConverterProvider, UnitCategory>(
      (state) => state.selectedCategory,
    );
    final compact = MediaQuery.sizeOf(context).width < 380;
    return Container(
      height: 58,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFF111017),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF24222E)),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : AppConstants.animationDuration,
            curve: Curves.easeOutCubic,
            alignment: Alignment(selected.index - 1.0, 0),
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF30283F),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: AppTheme.accent.withValues(alpha: 0.22),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: UnitCategory.values.map((category) {
              final active = selected == category;
              return Expanded(
                child: Semantics(
                  selected: active,
                  child: TextButton(
                    key: ValueKey(category),
                    onPressed: () =>
                        context.read<ConverterProvider>().setCategory(category),
                    style: TextButton.styleFrom(
                      foregroundColor: active
                          ? AppTheme.accent
                          : AppTheme.muted,
                      minimumSize: const Size(0, 48),
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 3 : 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category.icon, size: 17),
                          SizedBox(width: compact ? 4 : 7),
                          Text(
                            category.label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
