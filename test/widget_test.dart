import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unit_converter/app.dart';
import 'package:unit_converter/models/unit_category.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('10 Kilometer to Meter updates immediately to 10000 Meter', (
    tester,
  ) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('value-input')), '10');
    await tester.tap(find.byKey(const Key('swap-units')));
    await tester.pumpAndSettle();
    expect(find.text('10000 Meter'), findsOneWidget);
  });

  testWidgets('category and dropdown changes recalculate with valid units', (
    tester,
  ) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey(UnitCategory.temperature)));
    await tester.enterText(find.byKey(const Key('value-input')), '-40');
    await tester.pumpAndSettle();
    expect(find.text('-40 Fahrenheit'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('to-unit')));
    await tester.tap(find.byKey(const Key('to-unit')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Celsius').last);
    await tester.pumpAndSettle();
    expect(find.text('-40 Celsius'), findsOneWidget);
    await tester.ensureVisible(find.byTooltip('Clear value'));
    await tester.tap(find.byTooltip('Clear value'));
    await tester.pumpAndSettle();
    expect(find.text('—'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'small phones and large text remain scrollable without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const UnitConverterApp());
      await tester.pumpAndSettle();
      final context = tester.element(find.byType(Scaffold));
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      expect(MediaQuery.sizeOf(context).width, 320);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('conversion-result')));
      expect(find.text('0.025 Kilometer'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('numeric formatter rejects letters and repeated decimal points', (
    tester,
  ) async {
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle();
    final input = find.byKey(const Key('value-input'));
    await tester.enterText(input, '-12.5');
    await tester.pumpAndSettle();
    expect(find.text('-0.0125 Kilometer'), findsOneWidget);
    await tester.enterText(input, '12..5');
    await tester.pumpAndSettle();
    expect(find.text('-0.0125 Kilometer'), findsOneWidget);
    await tester.enterText(input, 'hello');
    await tester.pumpAndSettle();
    expect(find.text('-0.0125 Kilometer'), findsOneWidget);
  });
}
