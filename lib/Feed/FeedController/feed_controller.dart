import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:work_space/uri.dart';

class FeedController extends GetxController {
  var feed = [].obs;

  Future getFeed() async {
    var result = await http
        .get(Uri.parse('${MyUri().uri}getAllPosts'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    });

    feed(jsonDecode(result.body).toList());
    debugPrint('$feed');
  }
}
