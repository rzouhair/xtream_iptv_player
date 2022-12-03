import 'dart:convert';

import 'package:http/http.dart' as http;

class Channels {
  late dynamic stream_id;
  late dynamic id;
  late String name;
  late String stream_icon;

  Channels(this.stream_id, this.id, this.name, this.stream_icon);

  Channels.fromJson(Map<String, dynamic> json) {
    stream_id = json['stream_id'];
    id = json['id'];
    name = json['name'];
    stream_icon = json['stream_icon'];
  }

  static Future getAll(int category, logins) async {
    var channels = <Channels>[];

    var url = Uri.http(logins['host'], 'player_api.php', {
      'username': logins['username'],
      'password': logins['password'],
      'action': 'get_live_streams',
      'category_id': category.toString()
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonCategories = json.decode(response.body);

      for (var category in jsonCategories) {
        channels.add(Channels.fromJson(category));
      }
    }

    return channels;
  }
}
