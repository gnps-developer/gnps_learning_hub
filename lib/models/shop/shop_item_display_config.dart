class ShopItemDisplayConfig {
  final double scale;
  final double alignmentY;

  const ShopItemDisplayConfig({
    required this.scale,
    required this.alignmentY,
  });

  factory ShopItemDisplayConfig.fromJson(Map<String, dynamic> json) {
    return ShopItemDisplayConfig(
      scale: (json['scale'] as num).toDouble(),
      alignmentY: (json['alignmentY'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'scale': scale,
    'alignmentY': alignmentY,
  };
}
