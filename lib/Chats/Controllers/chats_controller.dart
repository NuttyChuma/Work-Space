import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/uri.dart';

class ChatsController extends GetxController {
  var messages = [].obs;
  var messagesWithUser = [].obs;

  getMessages() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // debugPrint(preferences.getString('userId')!);
    await http.post(Uri.parse('${MyUri().uri}getMessages'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    },
      body: jsonEncode(<String, String?>{
        'userId': preferences.getString('userId')
      })
    ).then((response) {
      // debugPrint(response.body);
      messages(jsonDecode(response.body).toList());
    });
  }

  sendMessage(message) async {
    messagesWithUser.add(message);
    // debugPrint('$message');
    await http.post(Uri.parse('${MyUri().uri}sendMessage'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    },
      body: jsonEncode(<String, dynamic>{
        'message': message,
      })
    ).then((response) {
      getMessages();
      // messages(jsonDecode(response.body).toList());
      // debugPrint('$messages');
    });
  }

  fetchMessages(String chatId){
    // debugPrint('$messages');
    for(var message in messages){
      var tmp = message['messages'];
      tmp.forEach((key,value){
        // debugPrint('$value');
        if(chatId == value['message']['chatId']){
          messagesWithUser.add(value['message']);
        }
      });
    }
  }
}