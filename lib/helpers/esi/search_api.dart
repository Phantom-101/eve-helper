import 'dart:convert';
import 'package:eve_helper/helpers/esi/esi_caller.dart';
import 'package:http/http.dart';

class SearchApi {
  Client _client;

  SearchApi(this._client);

  Future<int> getSolarSystemId(String name, {bool strict = false}) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/search/?categories=solar_system&datasource=tranquility&language=en-us&search=$name&strict=${strict.toString()}');

    if (response.statusCode == 200) {
      return json.decode(response.body).containsKey('solar_system') ? json.decode(response.body)['solar_system'][0] : -1;
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  Future<int> getInventoryTypeId(String name, {bool strict = false}) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/search/?categories=inventory_type&datasource=tranquility&language=en-us&search=$name&strict=${strict.toString()}');
    if (response.statusCode == 200) {
      return json.decode(response.body).containsKey('inventory_type') ? json.decode(response.body)['inventory_type'][0] : -1;
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  Future<int> getRegionId(String name, {bool strict = false}) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/search/?categories=region&datasource=tranquility&language=en-us&search=$name&strict=${strict.toString()}');

    if (response.statusCode == 200) {
      return json.decode(response.body).containsKey('region') ? json.decode(response.body)['region'][0] : -1;
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }
}