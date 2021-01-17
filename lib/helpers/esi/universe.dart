import 'dart:convert';
import 'package:eve_helper/data_structures.dart';
import 'package:http/http.dart' as http;

class Universe {
  static Future<String> getName(int id) async {
    return (await getNames([id]))[0];
  }

  static Future<List<String>> getNames(List<int> ids) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode(ids);
    final response = await http.post('https://esi.evetech.net/latest/universe/names/?datasource=tranquility', headers: headers, body: msg);

    if (response.statusCode == 200) {
      List<String> res = [];
      final decoded = json.decode(response.body);
      for(Map<String, dynamic> object in decoded)
        res.add(object['name']);
      return res;
    } else {
      throw Exception(response.statusCode);
    }
  }

  static Future<SolarSystemInformation> getSolarSystemInformation(int id) async {
    final response = await http.get('https://esi.evetech.net/latest/universe/systems/$id/?datasource=tranquility&language=en-us');

    if (response.statusCode == 200) {
      return SolarSystemInformation.fromJson(json.decode(response.body));
    } else {
      throw Exception(response.statusCode);
    }
  }
}