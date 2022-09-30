import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/uri.dart';

class ColleaguesController extends GetxController{
  var colleagues = [].obs;
  var colleaguesOnWorkSpace = [].obs;
  getChats() async{
    await http
        .get(Uri.parse('${MyUri().uri}getAllUsers'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    }).then((response){
      colleagues(jsonDecode(response.body).toList());
    });

    await http
        .get(Uri.parse('${MyUri().uri}getAppUsers'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    }).then((response){
      colleaguesOnWorkSpace(jsonDecode(response.body).toList());
    });

    // colleagues = List.from(colleagues);


    var suggestions = colleagues.where((user) {
      final email1 = user['email'].toLowerCase();
      bool isInWorkspace = false;
      for(int i = 0; i < colleaguesOnWorkSpace.length; i++){
        final email2 = colleaguesOnWorkSpace[i]['email'];
        if(email1 == email2){
          isInWorkspace = true;
        }
      }
      if(!isInWorkspace){
        return true;
      }
      return false;
    }).toList();

    colleagues(suggestions);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    suggestions = colleaguesOnWorkSpace.where((user) {
      final username = user['email'].toLowerCase();
      final input = sharedPreferences.getString('email');

      return username != input;
    }).toList();

    colleaguesOnWorkSpace(suggestions);

    // debugPrint('$colleaguesOnWorkSpace');

  }
}