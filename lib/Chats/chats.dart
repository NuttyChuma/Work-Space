import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:work_space/Chats/colleagues.dart';
import 'package:http/http.dart' as http;

import 'chat_messages.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  @override
  void initState() {
    getChats();
    super.initState();
  }

  List? chatsIds;
  List? chats = [];
  List? colleagues;
  getChats() async{
    String uri = 'http://192.168.3.68:5000/';
    var result = await http
        .post(Uri.parse('${uri}getChats'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    },
      body: jsonEncode(<String, dynamic>{
        'userId':0,
      })
    );
    chatsIds = jsonDecode(result.body).toList();

    var allUsers = await http
        .get(Uri.parse('${uri}getAllUsers'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    });
    colleagues = jsonDecode(allUsers.body).toList();
    getUsersWithChatsWith();

    setState(() {});
  }

  getUsersWithChatsWith(){
    for(dynamic user in colleagues!){
      // debugPrint('${user['chats']}');
      List? usersChatsIds = user['chats'];
      if(usersChatsIds != null && user['email'] != 'lweiner0@cam.ac.uk'){
        for(String userChatsId in usersChatsIds){
          for(String chatId in chatsIds!){
            if(userChatsId == chatId){
              chats!.add(user);
              break;
            }
          }
        }
      }
    }
    // debugPrint('${chats!.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple.shade300,
            expandedHeight: 100.0,
            floating: true,
            pinned: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Work Space'),
            ),
            actions: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
              IconButton (onPressed: (){}, icon: const Icon(Icons.more_vert_outlined)),
            ],
          ),
          (chats==null)? SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Container(
                  color: Colors.deepPurple.shade100,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.deepPurple.shade600,child: Text('$index'),),
                        title: Text('Chat $index'),
                        subtitle: const Text('some important busy people text'),
                        trailing: const Icon(Icons.favorite_border),
                      ),
                      const Divider(thickness: 2.0,),
                    ],
                  )
                );
              },
              childCount: 20,
            ),
          ):
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Container(
                  color: Colors.deepPurple.shade100,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.deepPurple.shade600,child: Text('${chats![index]['firstName'][0]}'),),
                        title: Text('${chats![index]['firstName']} ${chats![index]['lastName']}'),
                        subtitle: const Text('some important busy people text'),
                        trailing: const Icon(Icons.check_circle, color: Colors.blue,),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ChatMessages()));
                        },
                      ),
                      const Divider(thickness: 2.0,),
                    ],
                  ),
                );
              },
              childCount: chats!.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Colleagues(colleagues)));
        },
        backgroundColor: Colors.deepPurple.shade600,
        child: const Icon(Icons.chat),
      ),
    );
  }
}
