class MarketOrder {
  final int duration;
  final bool buyOrder;
  final String issued;
  final int locationId;
  final int minVolume;
  final int orderId;
  final double price;
  final String range;
  final int typeId;
  final int volumeRemain;
  final int volumeTotal;

  MarketOrder({this.duration, this.buyOrder, this.issued, this.locationId, this.minVolume, this.orderId, this.price, this.range, this.typeId, this.volumeRemain, this.volumeTotal});

  factory MarketOrder.fromJson(Map<String, dynamic> json) {
    return MarketOrder(
      duration: json['duration'],
      buyOrder: json['is_buy_order'],
      issued: json['issued'],
      locationId: json['location_id'],
      minVolume: json['min_volume'],
      orderId: json['order_id'],
      price: json['price'].toDouble(),
      range: json['range'],
      typeId: json['type_id'],
      volumeRemain: json['volume_remain'],
      volumeTotal: json['volume_total'],
    );
  }
}