---
name: Avatar Shop
description: Use when editing avatars, shop items, gems economy, daily goals, streaks
---

## When to use
Edits to `lib/models/avatar/`, `lib/models/shop/`, `lib/providers/shop_providers.dart`, `assets/avatars/`, `assets/shop/`, or `guides/SHOP_ITEMS.md`.

## Catalog (guides/SHOP_ITEMS.md)
- Headwear (Boy): None 0, Orange/Blue/Red Turban 600 each
- Clothes: Casual 0, Formal 800, Blue Kurta 1000, Blue Suit 1000
- Accessories: None 0, Glasses 300, Rounded Glasses 350, Sunglasses 450, Rounded Sunglasses 500
- Power-ups (stackable): Streak Freeze 250, Extra Heart 100

## Rules
1. SVG-based (`flutter_svg`), slots: Base, Skin Tone, Headwear (Turbans/Pins), Clothes, Accessories. Keep Both/Boy/Girl targeting consistent.
2. Prices in gems, integers only. Free defaults must remain 0. Power-ups `stackable: true`, cosmetics `false`.
3. Gems earned via learning (`lib/providers/progress_providers.dart`), spent via `shop_providers.dart` + Hive. Never grant gems without task/game completion.
4. Streak + Streak Freeze calendar in `lib/models/progress.dart` - freeze consumes inventory, protects missed day.
5. After shop data change, regenerate `guides/SHOP_ITEMS.md` if generator exists, else update manually.
