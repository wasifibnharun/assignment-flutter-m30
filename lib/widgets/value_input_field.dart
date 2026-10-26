import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_theme.dart';
import '../providers/converter_provider.dart';

class ValueInputField extends StatefulWidget {
  const ValueInputField({super.key});

  @override
  State<ValueInputField> createState() => _ValueInputFieldState();
}

class _ValueInputFieldState extends State<ValueInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<ConverterProvider>().inputText,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final symbol = context.select<ConverterProvider, String>(
      (state) => state.fromUnit.symbol,
    );
    final hasInput = context.select<ConverterProvider, bool>(
      (state) => state.inputText.isNotEmpty,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Enter value',
                style: TextStyle(color: AppTheme.muted, fontSize: 13),
              ),
            ),
            SizedBox(
              width: 32,
              height: 32,
              child: hasInput
                  ? IconButton(
                      tooltip: 'Clear value',
                      padding: EdgeInsets.zero,
                      iconSize: 17,
                      color: AppTheme.muted,
                      onPressed: () {
                        _controller.clear();
                        context.read<ConverterProvider>().setInput('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Semantics(
                label: 'Value to convert',
                child: TextField(
                  key: const Key('value-input'),
                  controller: _controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      // Permit incomplete signed decimals while typing.
                      return RegExp(r'^[+-]?\d*\.?\d*$').hasMatch(newValue.text)
                          ? newValue
                          : oldValue;
                    }),
                  ],
                  onChanged: context.read<ConverterProvider>().setInput,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -2,
                    height: 1.3,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Color(0xFF55515F)),
                    contentPadding: EdgeInsets.only(bottom: 8),
                    isDense: true,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF24202F),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                symbol,
                style: const TextStyle(color: AppTheme.accent, fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
