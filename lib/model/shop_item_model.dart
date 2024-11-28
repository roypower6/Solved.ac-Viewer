//코인샵 아이템 정보 모델
class ShopItemModel {
  final String itemId;
  final String itemImageUrl;
  final String displayName;
  final String displayDescription;
  final int price;
  final String priceUnit;
  final int units;

  ShopItemModel.fromJson(Map<String, dynamic> json)
      : itemId = json['item']['itemId'],
        itemImageUrl = json['item']['itemImageUrl'],
        displayName = json['item']['displayName'],
        displayDescription = json['item']['displayDescription'],
        price = json['price'],
        priceUnit = json['priceUnit'],
        units = json['units'];
}
