import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/shop/shop_item.dart';

class ShopRepository {
  Future<List<ShopItem>> getCatalog() async {
    final jsonString = await rootBundle.loadString('assets/data/shop_items.json');
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => ShopItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
