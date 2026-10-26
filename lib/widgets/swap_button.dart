import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../providers/converter_provider.dart';

class SwapButton extends StatefulWidget {
  const SwapButton({super.key});

  @override
  State<SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<SwapButton> {
  double _turns = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF292632))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B70EB).withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              key: const Key('swap-units'),
              tooltip: 'Swap units',
              onPressed: () {
                setState(() => _turns += 0.5);
                context.read<ConverterProvider>().swapUnits();
              },
              style: IconButton.styleFrom(
                minimumSize: const Size(48, 48),
                foregroundColor: const Color(0xFF151021),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: AnimatedRotation(
                turns: _turns,
                duration: MediaQuery.disableAnimationsOf(context)
                    ? Duration.zero
                    : AppConstants.animationDuration,
                curve: Curves.easeOutCubic,
                child: const Icon(Icons.swap_vert_rounded, size: 25),
              ),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFF292632))),
      ],
    );
  }
}
