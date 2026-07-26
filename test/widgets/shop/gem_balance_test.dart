import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/widgets/shop/gem_balance.dart';
import 'package:gnps_learning_hub/config/reward_config.dart';

void main() {
  testWidgets('GemBalance should display correct points and labels', (tester) async {
    const points = 1234;
    
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GemBalance(points: points),
        ),
      ),
    );

    expect(find.text('$points'), findsOneWidget);
    expect(find.text(RewardConfig.labelPlural), findsOneWidget);
    expect(find.byIcon(RewardConfig.icon), findsOneWidget);
  });
}
