enum AvatarSlot {
  base(0, 'Base Avatar'),
  skinTone(1, 'Skin Tone'),
  hair(2, 'Hair'),
  clothes(3, 'Clothes'),
  accessory(4, 'Accessory'),
  headwear(5, 'Headwear');

  final int layerOrder;
  final String displayName;

  const AvatarSlot(this.layerOrder, this.displayName);
}
