import 'package:eve_helper/data_structures/esi/market/market_stats.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class EveMarketer {
  static Future<MarketStats> getMarketStats(int id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=$id&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    return MarketStats.fromXml(doc, id, systemId);
  }

  static Future<double> getMinBuyPrice(int id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=$id&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    return double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('buy').getElement('min').text);
  }

  static Future<List<double>> getMinBuyPrices(List<int> id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=${id.join(',')}&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    Map<String, double> map = {};
    doc.getElement('exec_api').getElement('marketstat').children.forEach((node) {
      map[node.getAttribute('id')] = double.parse(node.getElement('buy').getElement('min').text);
    });

    List<double> prices = List<double>.filled(id.length, 0);
    for (int i = 0; i < id.length; i++) {
      prices[i] = map[id[i].toString()];
    }
    return prices;
  }

  static Future<double> getAvgBuyPrice(int id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=$id&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    return double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('buy').getElement('avg').text);
  }

  static Future<List<double>> getAvgBuyPrices(List<int> id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=${id.join(',')}&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    Map<String, double> map = {};
    doc.getElement('exec_api').getElement('marketstat').children.forEach((node) {
      map[node.getAttribute('id')] = double.parse(node.getElement('buy').getElement('avg').text);
    });

    List<double> prices = List<double>.filled(id.length, 0);
    for (int i = 0; i < id.length; i++) {
      prices[i] = map[id[i].toString()];
    }
    return prices;
  }

  static Future<double> getMaxBuyPrice(int id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=$id&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    return double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('buy').getElement('max').text);
  }

  static Future<List<double>> getMaxBuyPrices(List<int> id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=${id.join(',')}&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    Map<String, double> map = {};
    doc.getElement('exec_api').getElement('marketstat').children.forEach((node) {
      map[node.getAttribute('id')] = double.parse(node.getElement('buy').getElement('max').text);
    });

    List<double> prices = List<double>.filled(id.length, 0);
    for (int i = 0; i < id.length; i++) {
      prices[i] = map[id[i].toString()];
    }
    return prices;
  }

  static Future<double> getMinSellPrice(int id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=$id&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    return double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('sell').getElement('min').text);
  }

  static Future<List<double>> getMinSellPrices(List<int> id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=${id.join(',')}&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    Map<String, double> map = {};
    doc.getElement('exec_api').getElement('marketstat').children.forEach((node) {
      map[node.getAttribute('id')] = double.parse(node.getElement('sell').getElement('min').text);
    });

    List<double> prices = List<double>.filled(id.length, 0);
    for (int i = 0; i < id.length; i++) {
      prices[i] = map[id[i].toString()];
    }
    return prices;
  }

  static Future<double> getAvgSellPrice(int id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=$id&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    return double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('sell').getElement('avg').text);
  }

  static Future<List<double>> getAvgSellPrices(List<int> id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=${id.join(',')}&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    Map<String, double> map = {};
    doc.getElement('exec_api').getElement('marketstat').children.forEach((node) {
      map[node.getAttribute('id')] = double.parse(node.getElement('sell').getElement('avg').text);
    });

    List<double> prices = List<double>.filled(id.length, 0);
    for (int i = 0; i < id.length; i++) {
      prices[i] = map[id[i].toString()];
    }
    return prices;
  }

  static Future<double> getMaxSellPrice(int id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=$id&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    return double.parse(doc.getElement('exec_api').getElement('marketstat').getElement('type').getElement('sell').getElement('max').text);
  }

  static Future<List<double>> getMaxSellPrices(List<int> id, int systemId) async {
    final response = await http.get('https://api.evemarketer.com/ec/marketstat?typeid=${id.join(',')}&usesystem=$systemId');

    final doc = XmlDocument.parse(response.body);
    Map<String, double> map = {};
    doc.getElement('exec_api').getElement('marketstat').children.forEach((node) {
      map[node.getAttribute('id')] = double.parse(node.getElement('sell').getElement('max').text);
    });

    List<double> prices = List<double>.filled(id.length, 0);
    for (int i = 0; i < id.length; i++) {
      prices[i] = map[id[i].toString()];
    }
    return prices;
  }
}