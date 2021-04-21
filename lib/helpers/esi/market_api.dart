import 'dart:convert';
import 'package:eve_helper/data_structures/esi/market/aa_prices.dart';
import 'package:eve_helper/data_structures/esi/market/market_history.dart';
import 'package:eve_helper/data_structures/esi/market/market_order.dart';
import 'package:eve_helper/helpers/esi/esi_caller.dart';
import 'package:http/http.dart';

class MarketApi {
  Client _client;

  MarketApi(this._client);

  Future<List<AAPrices>> getAAPrices() async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/prices/?datasource=tranquility');

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => AAPrices.fromJson(obj)).toList().cast<AAPrices>();
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  Future<List<MarketHistory>> getMarketHistory(int id, int region) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/history/?datasource=tranquility&type_id=$id');

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => MarketHistory.fromJson(obj)).toList().cast<MarketHistory>();
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  Future<List<MarketOrder>> getMarketOrders(int region) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=all&page=1');
    if (response.statusCode != 200) {
      print ('${response.statusCode} ${response.body}');
      return <MarketOrder>[];
    }
    List<MarketOrder> res = json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    for (int page = 2; page <= int.parse(response.headers['x-pages']); page++) {
      final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=all&page=$page');
      if (response.statusCode != 200) {
        print ('${response.statusCode} ${response.body}');
        return res;
      }
      res.addAll(json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>());
    }
    return res;
  }

  Future<List<MarketOrder>> getMarketBuyOrders(int region) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=buy&page=1');
    if (response.statusCode != 200) {
      print ('${response.statusCode} ${response.body}');
      return <MarketOrder>[];
    }
    List<MarketOrder> res = json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    for (int page = 2; page <= int.parse(response.headers['x-pages']); page++) {
      final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=buy&page=$page');
      if (response.statusCode != 200) {
        print ('${response.statusCode} ${response.body}');
        return res;
      }
      res.addAll(json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>());
    }
    return res;
  }

  Future<List<MarketOrder>> getMarketSellOrders(int region) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=sell&page=1');
    if (response.statusCode != 200) {
      print ('${response.statusCode} ${response.body}');
      return <MarketOrder>[];
    }
    List<MarketOrder> res = json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    for (int page = 2; page <= int.parse(response.headers['x-pages']); page++) {
      final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=sell&page=$page');
      if (response.statusCode != 200) {
        print ('${response.statusCode} ${response.body}');
        return res;
      }
      res.addAll(json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>());
    }
    return res;
  }

  Future<List<MarketOrder>> getItemMarketOrders(int id, int region) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=all&page=1&type_id=$id');
    if (response.statusCode != 200) {
      print ('${response.statusCode} ${response.body}');
      return <MarketOrder>[];
    }
    List<MarketOrder> res = json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    for (int page = 2; page <= int.parse(response.headers['x-pages']); page++) {
      final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=all&page=$page&type_id=$id');
      if (response.statusCode != 200) {
        print ('${response.statusCode} ${response.body}');
        return res;
      }
      res.addAll(json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>());
    }
    return res;
  }

  Future<List<MarketOrder>> getItemMarketBuyOrders(int id, int region) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=buy&page=1&type_id=$id');
    if (response.statusCode != 200) {
      print ('${response.statusCode} ${response.body}');
      return <MarketOrder>[];
    }
    List<MarketOrder> res = json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    for (int page = 2; page <= int.parse(response.headers['x-pages']); page++) {
      final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=buy&page=$page&type_id=$id');
      if (response.statusCode != 200) {
        print ('${response.statusCode} ${response.body}');
        return res;
      }
      res.addAll(json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>());
    }
    return res;
  }

  Future<List<MarketOrder>> getItemMarketSellOrders(int id, int region) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=sell&page=1&type_id=$id');
    if (response.statusCode != 200) {
      print ('${response.statusCode} ${response.body}');
      return <MarketOrder>[];
    }
    List<MarketOrder> res = json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    for (int page = 2; page <= int.parse(response.headers['x-pages']); page++) {
      final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/$region/orders/?datasource=tranquility&order_type=sell&page=$page&type_id=$id');
      if (response.statusCode != 200) {
        print ('${response.statusCode} ${response.body}');
        return res;
      }
      res.addAll(json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>());
    }
    return res;
  }

  @deprecated
  Future<List<MarketOrder>> getMarketOrdersFromStructure(int id, String token, int page) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/markets/structures/$id/?datasource=tranquility&page=$page&token=$token');

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  @deprecated
  Future<List<MarketOrder>> getMarketOrdersFromLink(String link) async {
    final response = await EsiCaller.get(_client, '$link');

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => MarketOrder.fromJson(obj)).toList().cast<MarketOrder>();
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }
}