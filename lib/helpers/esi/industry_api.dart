import 'dart:convert';
import 'package:eve_helper/data_structures/esi/industry/solar_system_cost_indices.dart';
import 'package:http/http.dart';

class IndustryApi {
  Client _client;

  IndustryApi(this._client);

  Future<List<SolarSystemCostIndices>> getSolarSystemCostIndices() async {
    final response = await _client.get(Uri.parse('https://esi.evetech.net/latest/industry/systems/?datasource=tranquility'));

    if (response.statusCode == 200) {
      return json.decode(response.body).map((obj) => SolarSystemCostIndices.fromJson(obj)).toList().cast<SolarSystemCostIndices>();
    } else {
      throw Exception(response.statusCode);
    }
  }
}