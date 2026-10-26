import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/converter_provider.dart';
import 'screens/converter_screen.dart';

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConverterProvider(),
      child: MaterialApp(
        title: 'Unit Converter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: const ConverterScreen(),
      ),
    );
  }
}
