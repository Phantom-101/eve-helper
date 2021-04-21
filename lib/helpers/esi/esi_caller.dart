import 'package:http/http.dart';

class EsiCaller {
  static DateTime _canCall = DateTime.fromMillisecondsSinceEpoch(0);

  static Future<Response> get(Client client, String url, {Map<String, String> headers}) async {
    if (headers == null) headers = {};
    if (_canCall.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
      print('Waiting for ESI error limit reset');
      await Future.delayed(_canCall.difference(DateTime.now()) + Duration(milliseconds: 100));
    }
    Response rsp = await client.get(Uri.parse(url), headers: headers);
    if (int.parse(rsp.headers['x-esi-error-limit-remain'] ?? '100') == 0) {
      print('ESI error limit reached');
      _canCall = DateTime.now().add(Duration(seconds: int.parse(rsp.headers['x-esi-error-limit-reset'])));
    }
    return rsp;
  }

  static Future<Response> post(Client client, String url, {Map<String, String> headers, String body}) async {
    if (headers == null) headers = {};
    if (body == null) body = '';
    if (_canCall.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch) {
      print('Waiting for ESI error limit reset');
      await Future.delayed(_canCall.difference(DateTime.now()) + Duration(milliseconds: 100));
    }
    Response rsp = await client.post(Uri.parse(url), headers: headers, body: body);
    if (int.parse(rsp.headers['x-esi-error-limit-remain'] ?? '100') == 0) {
      print('ESI error limit reached');
      _canCall = DateTime.now().add(Duration(seconds: int.parse(rsp.headers['x-esi-error-limit-reset'])));
    }
    return rsp;
  }
}