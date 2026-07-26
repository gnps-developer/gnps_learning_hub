import '../data/shop_data.dart';
import '../models/shop_item.dart';

class ShopRepository {
  List<ShopItem> getCatalog() => shopCatalog;
}
