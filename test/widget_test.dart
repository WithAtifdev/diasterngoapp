import 'package:diaster_ngo_app/features/auth/view/Splasch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Disaster NGO splash screen renders smoke test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splaschscreen(),
      ),
    );

    expect(find.text('Disaster & NGO'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
