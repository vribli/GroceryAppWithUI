import 'dart:convert';

import 'package:grocery_app/models/results.dart';
import 'package:http/http.dart' as http;

class ProductApi {
  static Future<List<ApiSearchResult>> getResults(String query) async {
    // // Converting query string into format to put in API search
    // String querySplit = '';
    // if (query.length != 0) {
    //   String firstCharacter = querySplit.substring(0);
    //   String lastCharacter = querySplit.substring(querySplit.length - 1);
    //   if (lastCharacter == '+') {
    //     querySplit = querySplit.substring(0, querySplit.length - 1);
    //   }
    //   if (firstCharacter == '+') {
    //     querySplit = querySplit.substring(1, querySplit.length);
    //   }
    // }
    // API search
    final url = Uri.parse(
        'http://vribli.pythonanywhere.com/?keyword=' + query.replaceAll(" ", '+') + '&n=10');
    final response = await http.get(url);

    // Means if there are results from search
    if (response.statusCode == 200) {
      final List results = json.decode(response.body);

      return results.map((json) => ApiSearchResult.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }
}