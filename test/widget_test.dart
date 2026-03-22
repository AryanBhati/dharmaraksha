import 'package:flutter_test/flutter_test.dart';

import 'package:dharamraksha/main.dart';

void main() {
  testWidgets('app boots to splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DharamRakshaApp());

    expect(find.text('Legal clarity. Human empathy. Instant action.'),
        findsOneWidget);
  });
}
