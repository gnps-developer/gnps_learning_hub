import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnps_learning_hub/models/avatar/avatar_slot.dart';
import 'package:gnps_learning_hub/models/shop/shop_item.dart';
import 'package:gnps_learning_hub/models/shop/shop_item_category.dart';
import 'package:gnps_learning_hub/widgets/shop/shop_item_card.dart';

void main() {
  const testItem = ShopItem(
    id: 'test_item',
    name: 'Fancy Turban',
    description: 'A very fancy one.',
    price: 100,
    category: ShopItemCategory.item,
    avatarSlot: AvatarSlot.headwear,
    icon: Icons.face,
    color: Colors.orange,
  );

  testWidgets('ShopItemCard should display item details and call onBuy', (tester) async {
    bool buyCalled = false;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 160,
              height: 250,
              child: ShopItemCard(
                item: testItem,
                owned: false,
                quantity: 0,
                canAfford: true,
                onBuy: () => buyCalled = true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Fancy Turban'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    
    await tester.tap(find.byType(ElevatedButton));
    expect(buyCalled, true);
  });

  testWidgets('ShopItemCard should show Owned if non-stackable item is owned', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 160,
              height: 250,
              child: ShopItemCard(
                item: testItem,
                owned: true,
                quantity: 1,
                canAfford: true,
                onBuy: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Owned'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
  });
}
