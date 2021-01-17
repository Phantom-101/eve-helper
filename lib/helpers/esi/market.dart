import 'dart:convert';
import 'package:eve_helper/data_structures/esi/market/aa_prices.dart';
import 'package:eve_helper/data_structures/esi/market/market_history.dart';
import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:http/http.dart' as http;

class Market {
  static Future<List<AAPrices>> getAAPrices() async {
    final response = await http.get('https://esi.evetech.net/latest/markets/prices/?datasource=tranquility');

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => AAPrices.fromJson(obj)).toList().cast<AAPrices>();
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<List<MarketHistory>> getMarketHistory(int id, int region) async {
    final response = await http.get('https://esi.evetech.net/latest/markets/$region/history/?datasource=tranquility&type_id=$id');

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => MarketHistory.fromJson(obj)).toList().cast<MarketHistory>();
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<List<MarketOrder>> getMarketOrders(int id, int region) async {
    final response = await http.get('https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=all&page=1&type_id=$id');

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    } else {
      throw Exception(response.statusCode);
    }
  }

  @deprecated
  static Future<List<MarketOrder>> getMarketOrdersFromStructure(int id, String token, int page) async {
    final response = await http.get('https://esi.evetech.net/latest/markets/structures/$id/?datasource=tranquility&page=$page&token=$token');

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    } else {
      throw Exception(response.statusCode);
    }
  }

  @deprecated
  static Future<List<MarketOrder>> getMarketOrdersFromLink(String link) async {
    final response = await http.get('$link');

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    } else {
      throw Exception(response.statusCode);
    }
  }
}