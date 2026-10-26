import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../providers/converter_provider.dart';
import '../widgets/category_selector.dart';
import '../widgets/glass_card.dart';
import '../widgets/result_display.dart';
import '../widgets/swap_button.dart';
import '../widgets/unit_dropdown.dart';
import '../widgets/value_input_field.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _AmbientBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 600;
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(20, wide ? 48 : 24, 20, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppConstants.contentWidth,
                      ),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 650),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) => Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 18 * (1 - value)),
                            child: child,
                          ),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Header(),
                            SizedBox(height: 28),
                            CategorySelector(),
                            SizedBox(height: 18),
                            GlassCard(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    ValueInputField(),
                                    SizedBox(height: 18),
                                    Divider(
                                      height: 1,
                                      color: Color(0xFF2B2835),
                                    ),
                                    SizedBox(height: 22),
                                    UnitDropdown(isFrom: true),
                                    SizedBox(height: 12),
                                    SwapButton(),
                                    SizedBox(height: 4),
                                    UnitDropdown(isFrom: false),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 18),
                            ResultDisplay(),
                            SizedBox(height: 18),
                            _ConversionNote(),
                            SizedBox(height: 30),
                            _Footer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final categoryIndex = context.select<ConverterProvider, int>(
      (state) => state.selectedCategory.index + 1,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF262031),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF40334F)),
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: AppTheme.accent,
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'THE EVERYDAY TOOLKIT',
                style: TextStyle(
                  color: AppTheme.muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.8,
                ),
              ),
            ),
            Text(
              '0$categoryIndex / 03',
              style: const TextStyle(color: Color(0xFF66616F), fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 25),
        const Text(
          'Unit converter',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.3,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 9),
        const Text(
          'Different units. One simple answer.',
          style: TextStyle(fontSize: 13, color: AppTheme.muted),
        ),
      ],
    );
  }
}

class _ConversionNote extends StatelessWidget {
  const _ConversionNote();

  @override
  Widget build(BuildContext context) {
    final note = context.select<ConverterProvider, String>(
      (state) => state.conversionNote,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.info_outline_rounded, color: AppTheme.muted, size: 13),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            note,
            style: const TextStyle(color: AppTheme.muted, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.bolt_rounded, color: Color(0xFF686171), size: 13),
        SizedBox(width: 5),
        Flexible(
          child: Text(
            'Instant results',
            style: TextStyle(color: Color(0xFF77717F), fontSize: 10),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('·', style: TextStyle(color: Color(0xFF77717F))),
        ),
        Icon(Icons.check_circle_outline, color: Color(0xFF686171), size: 12),
        SizedBox(width: 5),
        Flexible(
          child: Text(
            'No connection needed',
            style: TextStyle(color: Color(0xFF77717F), fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0A0F), Color(0xFF12111A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.1, -0.35),
            radius: 0.65,
            colors: [Color(0x188C60E0), Color(0x008C60E0)],
          ),
        ),
      ),
    );
  }
}
