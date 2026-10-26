import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../providers/converter_provider.dart';

class ResultDisplay extends StatelessWidget {
  const ResultDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final display = context.select<ConverterProvider, (String, String)>(
      (state) => (state.formattedResult, state.resultHint),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF252034), Color(0xFF1B1827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF403451)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'CONVERTED RESULT',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.7,
                  ),
                ),
              ),
              Icon(Icons.north_east_rounded, size: 17, color: AppTheme.accent),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            display.$2,
            style: const TextStyle(color: AppTheme.muted, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Semantics(
            liveRegion: true,
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: AnimatedSwitcher(
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : AppConstants.animationDuration,
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                layoutBuilder: (current, previous) => Stack(
                  alignment: Alignment.centerLeft,
                  children: [...previous, ?current],
                ),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.15),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: FittedBox(
                  key: ValueKey(display.$1),
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    display.$1,
                    key: const Key('conversion-result'),
                    style: const TextStyle(
                      color: Color(0xFFD0C3FF),
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
