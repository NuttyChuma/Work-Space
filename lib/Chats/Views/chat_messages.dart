import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
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

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final chatsController = Get.find<ChatsController>();
  String message = '';
  var arguments = Get.arguments;
  String? username;

  @override
  void initState() {
    getUsername();
    scrollDown();
    super.initState();
  }

  getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username');
    setState(() {});
  }

  scrollDown() async {
    await Future.delayed(const Duration(milliseconds: 1));
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    chatsController.messagesWithUser.sort((m1, m2) {
      var r = m1["sentAt"].compareTo(m2["sentAt"]);
      if (r != 0) return r;
      return m1["sentAt"].compareTo(m2["sentAt"]);
    });

    return WillPopScope(
        onWillPop: () {
          chatsController.messagesWithUser = [].obs;
          return Future(() => true);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.deepPurple.shade100,
            appBar: AppBar(
              backgroundColor: Colors.deepPurple.shade300,
              title: Text(arguments[0]),
              actions: const [Icon(Icons.more_vert_rounded)],
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                      child: Obx(
                    () => ListView.builder(
                      padding: const EdgeInsets.only(bottom: 5.0),
                        controller: _scrollController,
                        itemCount: chatsController.messagesWithUser.length,
                        itemBuilder: (context, index) {
                          bool dateChip = false;
                          bool tail = true;
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
                          if(index != 0){
                            if(chatsController.messagesWithUser[index]['from']==chatsController
                                .messagesWithUser[index-1]['from']){
                              tail = false;
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
                                  BubbleSpecialOne(
                                    text: chatsController
                                        .messagesWithUser[index]['message'],
                                    color:
                                        (chatsController.messagesWithUser[index]
                                                    ['from'] ==
                                                username)
                                            ? const Color(0xFF1B97F3)
                                            : const Color(0xFF0007F3),
                                    isSender:
                                        (chatsController.messagesWithUser[index]
                                                    ['from'] ==
                                                username)
                                            ? true
                                            : false,
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    tail: tail,
                                    sent: true,
                                    delivered: true,
                                    seen: true,
                                  ),
                                ],
                              ));
                        }),
                  )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 55,
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            child: TextFormField(
                              controller: _textController,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 1,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type a message...',
                                  prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.emoji_emotions)),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.attach_file_rounded)),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.camera_alt)),
                                    ],
                                  ),
                                  contentPadding: const EdgeInsets.all(5.0)),
                              onChanged: (message) {
                                this.message = message;
                              },
                              onTap: () async{
                                await Future.delayed(const Duration(milliseconds: 350));
                                _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent,
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 2.0),
                          child: CircleAvatar(
                            radius: 25.0,
                            child: IconButton(
                                onPressed: () async {
                                  message = message.trim();
                                  SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                  if (message.isNotEmpty) {
                                    dynamic month = DateTime.now().month;
                                    if (month < 10) {
                                      month = '0$month';
                                    }
                                    dynamic day = DateTime.now().day;
                                    if (day < 10) {
                                      day = '0$day';
                                    }
                                    dynamic hour = DateTime.now().hour;
                                    if (hour < 10) {
                                      hour = '0$hour';
                                    }
                                    dynamic minute = DateTime.now().minute;
                                    if (minute < 10) {
                                      minute = '0$minute';
                                    }
                                    dynamic second = DateTime.now().second;
                                    if (second < 10) {
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
                                      'user1': {
                                        'userId': arguments[2],
                                        'username':
                                            preferences.getString('username')
                                      },
                                      'user2': {
                                        'userId': arguments[3],
                                        'username': arguments[0]
                                      },
                                    };
                                    chatsController.sendMessage(messageData);
                                    _textController.clear();
                                  }
                                  await Future.delayed(const Duration(milliseconds: 500));
                                  _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.fastOutSlowIn);
                                  // Get.snackbar(
                                  //   preferences.getString('username')!,
                                  //   message,
                                  //   icon: const Icon(Icons.person, color: Colors.white),
                                  //   // snackPosition: SnackPosition.BOTTOM,
                                  //   // backgroundColor: Colors.green,
                                  // );
                                  message = '';
                                },
                                icon: const Icon(Icons.send)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
    );
  }
}