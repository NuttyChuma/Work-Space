import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/uri.dart';

class ChatsController extends GetxController {
  var messages = [].obs;
  var messagesWithUser = [].obs;
  var chatId = '';
  var isLaunch = true;
  var avoidSecondSnackBar = false;

  getMessages() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await http.post(Uri.parse('${MyUri().uri}getMessages'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    },
      body: jsonEncode(<String, String?>{
        'userId': preferences.getString('userId')
      })
    ).then((response) {
      List responseList = jsonDecode(response.body).toList();
      if(responseList.isNotEmpty){
        messages(responseList);
        // debugPrint('${messages[0]['latestMessage']['message']}');
        messages.sort((m1, m2) {
          var r = m1['latestMessage']["sentAt"].compareTo(m2['latestMessage']["sentAt"]);
          if (r != 0) return r;
          return m1['latestMessage']["sentAt"].compareTo(m2['latestMessage']["sentAt"]);
        });
        messages = messages.reversed.toList().obs;
      }

    });
  }

  sendMessage(message) async {
    messagesWithUser.add(message);
    await http.post(Uri.parse('${MyUri().uri}sendMessage'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    },
      body: jsonEncode(<String, dynamic>{
        'message': message,
      })
    ).then((response) {
      getMessages();
    });
  }

  fetchMessages(String chatId){
    this.chatId = chatId;
    messagesWithUser([]);
    for(var message in messages){
      var tmp = message['messages'];
      tmp.forEach((key,value){
        if(chatId == value['message']['chatId']){
          messagesWithUser.add(value['message']);
        }
      });
    }
  }

  listenToDatabase() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('userId');

    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('messages/$userId/');
    starCountRef.onValue.listen((DatabaseEvent event) async {
      if(event.snapshot.exists){
        debugPrint('Hello We Are Listening');
        await getMessages();
        messagesWithUser([]);
        if(chatId.isNotEmpty){
          await fetchMessages(chatId);
        }
        List newMessages = [];
        for(var message in messages){
          var tmp = message['messages'];
          tmp.forEach((key,value){
            newMessages.add(value['message']);
          });
        }

        newMessages.sort((m1, m2) {
          var r = m1["sentAt"].compareTo(m2["sentAt"]);
          if (r != 0) return r;
          return m1["sentAt"].compareTo(m2["sentAt"]);
        });
        debugPrint('${newMessages[newMessages.length-1]['message']}');

        if(newMessages[newMessages.length-1]['from'] != preferences.getString('username') && !isLaunch){
          if(!avoidSecondSnackBar){
            Get.snackbar(
              newMessages[newMessages.length-1]['from'],
              newMessages[newMessages.length-1]['message'],
              icon: const Icon(Icons.person, color: Colors.white),
            );
            avoidSecondSnackBar = true;
          }else{
            avoidSecondSnackBar = false;
          }
        }else{
          isLaunch = false;
        }
      }
    });
    // debugPrint('Hello');
  }
}

// tbernardoni@shutterfly.com