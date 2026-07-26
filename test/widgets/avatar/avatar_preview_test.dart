import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/shop_item.dart';
import 'package:gnps_learning_hub/widgets/avatar/avatar_preview.dart';

void main() {
  const catalog = [
    ShopItem(
      id: 'base_boy',
      name: 'Boy',
      description: 'B',
      price: 0,
      category: ShopItemCategory.item,
      avatarSlot: AvatarSlot.base,
      icon: Icons.person,
      color: Colors.blue,
    ),
  ];

  testWidgets('AvatarPreview should render base icon if no SVG is provided', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AvatarPreview(
            equippedItemIds: {
              'base': 'base_boy',
            },
            catalog: catalog,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
