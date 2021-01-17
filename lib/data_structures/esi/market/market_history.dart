class MarketHistory {
  final double average;
  final String date;
  final double highest;
  final double lowest;
  final int orders;
  final int volume;

  MarketHistory({this.average, this.date, this.highest, this.lowest, this.orders, this.volume});

  factory MarketHistory.fromJson(Map<String, dynamic> json) {
    return MarketHistory(
      average: json['average'].toDouble(),
      date: json['date'],
      highest: json['highest'].toDouble(),
      lowest: json['lowest'].toDouble(),
      orders: json['order_count'],
      volume: json['volume'],
    );
  }
}