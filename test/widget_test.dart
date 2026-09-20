// Basic smoke test: verifies the app boots and shows the splash screen
// without throwing.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vidzora/app/vidzora_app.dart';

void main() {
  testWidgets('Vidzora app boots and shows splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: VidzoraApp()),
    );
    await tester.pump();

    expect(find.text('Vidzora'), findsOneWidget);
  });
}
