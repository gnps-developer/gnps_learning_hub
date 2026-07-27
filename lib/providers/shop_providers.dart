import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/shop/shop_item.dart';
import '../repositories/shop_repository.dart';

final shopRepositoryProvider = Provider((ref) => ShopRepository());

final shopCatalogProvider = Provider<List<ShopItem>>((ref) {
  final repository = ref.watch(shopRepositoryProvider);
  return repository.getCatalog();
});
