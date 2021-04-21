import 'dart:convert';
import 'package:eve_helper/data_structures.dart';
import 'package:http/http.dart' as http;

class Kybernaut {
  static Future<List<InvadedSolarSystemInformation>> getInvadedSolarSystemInformation() async {
    final response = await http.get(Uri.parse('https://kybernaut.space/invasions.json'));

    List<InvadedSolarSystemInformation> invadedSolarSystems = [];
    List<Map<String, dynamic>> json = jsonDecode(response.body).cast<Map<String, dynamic>>();
    for (Map<String, dynamic> systemInfo in json)
      invadedSolarSystems.add(InvadedSolarSystemInformation.fromJson(systemInfo));
    return invadedSolarSystems;
  }
}