import 'dart:convert';
import 'package:http/http.dart';

class RoutesApi {
  Client _client;

  RoutesApi(this._client);

  Future<List<int>> getRoute(int origin, int destination) async {
    return await getRouteWithFlag(origin, destination, 'shortest');
  }

  Future<List<int>> getRouteWithFlag(int origin, int destination, String flag) async {
    final response = await _client.get(Uri.parse('https://esi.evetech.net/latest/route/$origin/$destination/?datasource=tranquility&flag=$flag'));

    if (response.statusCode == 200) {
      return json.decode(response.body).cast<int>();
    } else {
      throw Exception(response.statusCode);
    }
  }
}