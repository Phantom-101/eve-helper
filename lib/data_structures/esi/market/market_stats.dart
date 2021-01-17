import 'package:xml/xml.dart';

class MarketStats {
  final double minSell;
  final double avgSell;
  final double maxSell;
  final double minBuy;
  final double avgBuy;
  final double maxBuy;
  final int typeId;
  final int systemId;

  MarketStats({this.minSell, this.avgSell, this.maxSell, this.minBuy, this.avgBuy, this.maxBuy, this.typeId, this.systemId});

  factory MarketStats.fromXml(XmlDocument doc, int typeId, int systemId) {
    return MarketStats(
      minSell: double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('sell').getElement('min').text),
      avgSell: double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('sell').getElement('avg').text),
      maxSell: double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('sell').getElement('max').text),
      minBuy: double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('buy').getElement('min').text),
      avgBuy: double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('buy').getElement('avg').text),
      maxBuy: double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('buy').getElement('max').text),
      typeId: typeId,
      systemId: systemId,
    );
  }
}