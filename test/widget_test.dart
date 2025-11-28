import 'package:flutter_test/flutter_test.dart';
import 'package:pigeon_git_action_demo/main.dart';

void main() {
  testWidgets('App should build', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Pigeon Demo'), findsOneWidget);
  });
}