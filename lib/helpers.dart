import 'dart:convert';
import 'package:eve_helper/data_structures.dart';
import 'package:http/http.dart' as http;

class Helpers {
  static Future<AlphaTrainableSkillList> getAlphaTrainableSkills() async {
    final response = await http.get(Uri.parse('https://sde.hoboleaks.space/tq/clonestates.json'));

    if (response.statusCode == 200) {
      return AlphaTrainableSkillList.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load alpha trainable skills');
    }
  }

  static Future<BlueprintInformation> getBlueprintInformation(int id) async {
    final response = await http.get(Uri.parse('https://www.fuzzwork.co.uk/blueprint/api/blueprint.php?typeid=$id'));

    if (response.statusCode == 200) {
      return BlueprintInformation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to retrieve blueprint information');
    }
  }

  @deprecated
  static Future<int> getItemId(String name) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    final msg = jsonEncode([name]);
    final response = await http.post(Uri.parse('https://esi.evetech.net/latest/universe/ids/?datasource=tranquility&language=en-us'), headers: headers, body: msg);

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception(response.statusCode);
    }
  }
}