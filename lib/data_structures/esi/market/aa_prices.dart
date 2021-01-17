class AAPrices {
  final double adjustedPrice;
  final double averagePrice;
  final int typeId;

  AAPrices({this.adjustedPrice, this.averagePrice, this.typeId});

  factory AAPrices.fromJson(Map<String, dynamic> json) {
    return AAPrices(
      adjustedPrice: json['adjusted_price'],
      averagePrice: json['average_price'],
      typeId: json['type_id'],
    );
  }
}