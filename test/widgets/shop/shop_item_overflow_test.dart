import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/shop/shop_item.dart';
import 'package:gnps_learning_hub/models/shop/shop_item_category.dart';
import 'package:gnps_learning_hub/widgets/shop/shop_item_card.dart';

void main() {
  testWidgets('ShopItemCard should not overflow with stackable power-up', (tester) async {
    const powerUp = ShopItem(
      id: 'powerup_test',
      name: 'Extra Heart',
      description: 'Gives you an extra life in games.',
      icon: Icons.favorite,
      color: Colors.red,
      price: 20,
      category: ShopItemCategory.powerUp,
      stackable: true,
    );

    // Set a common mobile width (e.g., 360)
    // GridView with crossAxisCount: 2 and some padding/spacing
    // (360 - 12*2 - 8) / 2 = 164 wide
    // With childAspectRatio: 0.64, height = 164 / 0.64 = 256
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 164,
              height: 256,
              child: ShopItemCard(
                item: powerUp,
                owned: true,
                quantity: 5,
                canAfford: true,
                onBuy: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
