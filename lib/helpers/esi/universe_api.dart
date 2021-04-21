import 'dart:convert';
import 'package:eve_helper/data_structures.dart';
import 'package:eve_helper/data_structures/esi/locations/constellation_information.dart';
import 'package:eve_helper/data_structures/esi/locations/station_information.dart';
import 'package:eve_helper/data_structures/esi/locations/structure_information.dart';
import 'package:eve_helper/data_structures/esi/type_information.dart';
import 'package:eve_helper/helpers/esi/esi_caller.dart';
import 'package:http/http.dart';

class UniverseApi {
  Client _client;

  UniverseApi(this._client);

  Future<String> getName(int id) async {
    return (await getNames([id]))[0];
  }

  Future<List<String>> getNames(List<int> ids) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode(ids);
    final response = await EsiCaller.post(_client, 'https://esi.evetech.net/latest/universe/names/?datasource=tranquility', headers: headers, body: msg);

    if (response.statusCode == 200) {
      List<String> res = [];
      final decoded = json.decode(response.body);
      for(Map<String, dynamic> object in decoded)
        res.add(object['name']);
      return res;
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  Future<TypeInformation> getTypeInformation(int id) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/universe/types/$id/?datasource=tranquility&language=en');

    if (response.statusCode == 200) {
      return TypeInformation.fromJson(json.decode(response.body));
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  Future<ConstellationInformation> getConstellationInformation(int id) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/universe/constellations/$id/?datasource=tranquility&language=en');

    if (response.statusCode == 200) {
      return ConstellationInformation.fromJson(json.decode(response.body));
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  Future<SolarSystemInformation> getSolarSystemInformation(int id) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/universe/systems/$id/?datasource=tranquility&language=en-us');

    if (response.statusCode == 200) {
      return SolarSystemInformation.fromJson(json.decode(response.body));
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  Future<StationInformation> getStationInformation(int id) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/universe/stations/$id/?datasource=tranquility');

    if (response.statusCode == 200) {
      return StationInformation.fromJson(json.decode(response.body));
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }

  Future<StructureInformation> getStructureInformation(int id) async {
    final response = await EsiCaller.get(_client, 'https://esi.evetech.net/latest/universe/structures/$id/?datasource=tranquility');

    if (response.statusCode == 200) {
      return StructureInformation.fromJson(json.decode(response.body));
    } else {
      throw Exception('${response.statusCode} ${response.body}');
    }
  }
}