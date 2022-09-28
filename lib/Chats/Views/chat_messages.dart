import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/Chats/Controllers/chats_controller.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  // List messages = [
  //   {'from': 'Liliane Weiner', 'to': 'Ruperto Renyard', 'message': 'Hello Ruperto', 'sentAt':'20220927175506', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Liliane Weiner', 'to': 'Ruperto Renyard', 'message': 'How you doing?', 'sentAt':'20220927180113', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Liliane Weiner', 'to': 'Ruperto Renyard', 'message': 'I\'m also good too thanks', 'sentAt':'20220927180303', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Liliane Weiner', 'to': 'Ruperto Renyard', 'message': 'I was just checking up on you', 'sentAt':'20220927180340', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Liliane Weiner', 'to': 'Ruperto Renyard', 'message': 'How\'s everything going though?', 'sentAt':'20220927180443', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Liliane Weiner', 'to': 'Ruperto Renyard', 'message': 'Ah you know just hanging on', 'sentAt':'20220927180739', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Liliane Weiner', 'to': 'Ruperto Renyard', 'message': 'Oh okay It\'s cool. Bye', 'sentAt':'20220927181023', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'Hey Liliane', 'sentAt':'20220927175841', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'I\'m doing good thanks and you?', 'sentAt':'20220927180201', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'Things are going alright you know and your side?', 'sentAt':'20220927180553', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'Actually I\'m on my way to class right now, talk to you after?', 'sentAt':'20220927180920', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'Bye', 'sentAt':'20220927181057', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'Hey Liliane', 'sentAt':'20220927175841', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'I\'m doing good thanks and you?', 'sentAt':'20220927180201', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'Things are going alright you know and your side?', 'sentAt':'20220927180553', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'Actually I\'m on my way to class right now, talk to you after?', 'sentAt':'20220927180920', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  //   {'from': 'Ruperto Renyard', 'to': 'Liliane Weiner', 'message': 'Bye', 'sentAt':'20220927181057', 'status':'read', 'messageId':'chat1Id+chat2Id',},
  // ];

  final TextEditingController _textController = TextEditingController();
  final chatsController = Get.find<ChatsController>();
  String message = '';
  var arguments = Get.arguments;
  String? username;

  @override
  void initState() {
    getUsername();
    super.initState();
  }
  getUsername()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    chatsController.messagesWithUser.sort((m1, m2) {
      var r = m1["sentAt"].compareTo(m2["sentAt"]);
      // debugPrint('$r');
      if (r != 0) return r;
      return m1["sentAt"].compareTo(m2["sentAt"]);
    });
    return WillPopScope(
      onWillPop: () {
        chatsController.messagesWithUser = [].obs;
        return Future(() => true);
      },
      child: Scaffold(
          backgroundColor: Colors.deepPurple.shade100,
          body: Stack(
            children: [
              Obx(() => CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.deepPurple.shade300,
                    title: Text(arguments[0]),
                    actions: const [Icon(Icons.more_vert_rounded)],
                    pinned: true,
                    floating: true,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        bool dateChip = false;
                        int year = int.parse(chatsController
                            .messagesWithUser[index]['sentAt']
                            .substring(0, 4));
                        int month = int.parse(chatsController
                            .messagesWithUser[index]['sentAt']
                            .substring(4, 6));
                        int day = int.parse(chatsController
                            .messagesWithUser[index]['sentAt']
                            .substring(6, 8));
                        if (index != 0) {
                          int sentAt = int.parse(chatsController
                              .messagesWithUser[index]['sentAt']
                              .substring(0, 8));
                          int sentAtLast = int.parse(chatsController
                              .messagesWithUser[index - 1]['sentAt']
                              .substring(0, 8));
                          if (sentAt != sentAtLast) {
                            dateChip = true;
                          }
                        }
                        return Container(
                            color: Colors.deepPurple.shade100,
                            child: Column(
                              children: [
                                if (index == 0 || dateChip)
                                  DateChip(
                                    date: DateTime(year, month, day),
                                  ),
                                BubbleSpecialThree(
                                  text: chatsController.messagesWithUser[index]
                                  ['message'],
                                  color: (chatsController.messagesWithUser[index]
                                  ['from'] ==
                                      username)
                                      ? const Color(0xFF1B97F3)
                                      : const Color(0xFF0007F3),
                                  tail: true,
                                  isSender: (chatsController
                                      .messagesWithUser[index]['from'] ==
                                      username)
                                      ? true
                                      : false,
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ));
                      },
                      childCount: chatsController.messagesWithUser.length,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 60.0,
                    ),
                  ),
                ],
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.deepPurple.shade100,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 55,
                        // height: 69.0,
                        // color: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: TextFormField(
                          controller: _textController,
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Message',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 0.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 0.0),
                            ),
                          ),
                          onChanged: (message) {
                            this.message = message;
                          },
                        ),
                      ),
                      CircleAvatar(
                        radius: 25,
                        child: IconButton(
                            onPressed: () async {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              dynamic month = DateTime.now().month;
                              if(month < 10){
                                month = '0$month';
                              }
                              dynamic day = DateTime.now().day;
                              if(day < 10){
                                day = '0$day';
                              }
                              dynamic hour = DateTime.now().hour;
                              if(hour < 10){
                                hour = '0$hour';
                              }
                              dynamic minute = DateTime.now().minute;
                              if(minute < 10){
                                minute = '0$minute';
                              }
                              dynamic second = DateTime.now().second;
                              if(second < 10){
                                second = '0$second';
                              }

                              String sentAt =
                                  '${DateTime.now().year}$month$day$hour$minute$second';
                              var messageData = {
                                'from': preferences.getString('username'),
                                'to': arguments[0],
                                'message': message,
                                'sentAt': sentAt,
                                'status': 'notSent',
                                'chatId': arguments[1],
                                'user1': {'userId':arguments[2], 'username':preferences.getString('username')},
                                'user2': {'userId':arguments[3], 'username':arguments[0]},
                              };
                              chatsController.sendMessage(messageData);
                              _textController.clear();
                            },
                            icon: const Icon(Icons.send)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
