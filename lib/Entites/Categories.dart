import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Category {
  late String categorie_id;
  late String categorie_name;
  late int parent_id;

  Category(this.categorie_id, this.categorie_name, this.parent_id);

  Category.fromJson(Map<String, dynamic> json) {
    categorie_id = json['category_id'];
    categorie_name = json['category_name'];
    parent_id = json['parent_id'];
  }

  static Future getAll(type, logins) async {
    var categories = <Category>[];

    String action = 'get_${type}_categories';
    var url = Uri.http(logins['host'], 'player_api.php', {
      'username': logins['username'],
      'password': logins['password'],
      'action': action
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonCategories = json.decode(response.body);

      for (var category in jsonCategories) {
        categories.add(Category.fromJson(category));
      }
    }

    return categories;
  }

  static String buildUrl(String url, Map<String, dynamic> params) {
    String finalUrl = '';
    String qs = '';

    for (String k in params.keys) {
      qs += '$k=${params[k]}&';
    }

    if (qs.isNotEmpty) {
      qs = qs.substring(0, qs.length - 1); // chop off the last &
      finalUrl = '$url?$qs';
    }

    debugPrint(finalUrl);
    return finalUrl;
  }
}
