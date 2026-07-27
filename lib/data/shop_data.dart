import '../models/shop/shop_item.dart';
import 'shop/default_items.dart';
import 'shop/shop_items.dart';

export 'shop/default_items.dart';
export 'shop/shop_items.dart';

const List<ShopItem> shopCatalog = [
  ...defaultItems,
  ...purchasableItems,
];
