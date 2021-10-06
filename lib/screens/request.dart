import 'package:http/http.dart';

Future getAPI(url) async {
  Response response = await get(Uri.parse(url));
  return response.body;
}