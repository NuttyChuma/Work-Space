import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/Chats/Controllers/chats_controller.dart';
import 'package:work_space/Chats/Controllers/colleagues_controller.dart';
import 'package:work_space/Chats/Views/chat_messages.dart';

class Colleagues extends StatefulWidget {
  const Colleagues({Key? key}) : super(key: key);

  @override
  State<Colleagues> createState() => _ColleaguesState();
}

class _ColleaguesState extends State<Colleagues> {
  final colleaguesController = Get.find<ColleaguesController>();
  final chatsController = Get.find<ChatsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.deepPurple.shade300,
                  floating: true,
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: Text('Colleagues'),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.search)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_outlined)),
                  ],
                ),
                if (colleaguesController.colleaguesOnWorkSpace.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                        color: Colors.deepPurple.shade100,
                        child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('Colleagues On Workspace'))),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                          // height: 60.0,
                          color: Colors.deepPurple.shade100,
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.deepPurple.shade600,
                                  child: Text(
                                      '${colleaguesController.colleaguesOnWorkSpace[index]['firstName'][0]}'),
                                ),
                                title: Text(
                                    '${colleaguesController.colleaguesOnWorkSpace[index]['firstName']} ${colleaguesController.colleaguesOnWorkSpace[index]['lastName']}'),
                                subtitle: Text(
                                    'From ${colleaguesController.colleaguesOnWorkSpace[index]['department']}'),
                                onTap: () {
                                  openDialog(index, true);
                                },
                              ),
                              const Divider(
                                thickness: 2.0,
                              ),
                            ],
                          ));
                    },
                    childCount:
                        colleaguesController.colleaguesOnWorkSpace.length,
                  ),
                ),
                if (colleaguesController.colleagues.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                        color: Colors.deepPurple.shade100,
                        child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text('Colleagues Not On Workspace'))),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                          // height: 60.0,
                          color: Colors.deepPurple.shade100,
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.deepPurple.shade600,
                                  child: Text(
                                      '${colleaguesController.colleagues[index]['firstName'][0]}'),
                                ),
                                title: Text(
                                    '${colleaguesController.colleagues[index]['firstName']} ${colleaguesController.colleagues[index]['lastName']}'),
                                subtitle: Text(
                                    'From ${colleaguesController.colleagues[index]['department']}'),
                                onTap: () {
                                  openDialog(index, false);
                                },
                              ),
                              const Divider(
                                thickness: 2.0,
                              ),
                            ],
                          ));
                    },
                    childCount: colleaguesController.colleagues.length,
                  ),
                ),
                // (colleaguesController.colleagues.isNotEmpty)
                //     ? SliverList(
                //         delegate: SliverChildBuilderDelegate(
                //           (context, index) {
                //             return Container(
                //                 // height: 60.0,
                //                 color: Colors.deepPurple.shade100,
                //                 child: Column(
                //                   children: [
                //                     ListTile(
                //                       leading: CircleAvatar(
                //                         backgroundColor:
                //                             Colors.deepPurple.shade600,
                //                         child: Text(
                //                             '${colleaguesController.colleagues[index]['firstName'][0]}'),
                //                       ),
                //                       title: Text(
                //                           '${colleaguesController.colleagues[index]['firstName']} ${colleaguesController.colleagues[index]['lastName']}'),
                //                       subtitle: Text(
                //                           'From ${colleaguesController.colleagues[index]['department']}'),
                //                       onTap: () {
                //                         openDialog(index);
                //                       },
                //                     ),
                //                     const Divider(
                //                       thickness: 2.0,
                //                     ),
                //                   ],
                //                 ));
                //           },
                //           childCount: colleaguesController.colleagues.length,
                //         ),
                //       )
                //     : SliverToBoxAdapter(
                //         child: SizedBox(
                //           height: MediaQuery.of(context).size.height,
                //           child: Center(
                //             child: CircularProgressIndicator(
                //               color: Colors.deepPurple.shade600,
                //             ),
                //           ),
                //         ),
                //       ),
              ],
            )));
  }

  Future openDialog(int index, bool isOnWorkSpace) {
    // debugPrint('${colleaguesController.colleagues[index]}');
    String username =
        '${colleaguesController.colleaguesOnWorkSpace[index]['firstName']} ${colleaguesController.colleaguesOnWorkSpace[index]['lastName']}';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple.shade50,
            title: Text(username),
            content: SizedBox(
              height: 60.0,
              child: Column(
                children: [
                  Text(
                      'Email: ${colleaguesController.colleaguesOnWorkSpace[index]['email']}'),
                  Text(
                      'Emp No. ${colleaguesController.colleaguesOnWorkSpace[index]['empNum']}'),
                  Text(
                      'Works in ${colleaguesController.colleaguesOnWorkSpace[index]['department']}'),
                ],
              ),
            ),
            actions: [
              (isOnWorkSpace)
                  ? TextButton(
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        String friendId = colleaguesController
                            .colleaguesOnWorkSpace[index]['uuid'];
                        String userId = preferences.getString('userId')!;
                        int response = userId.compareTo(friendId);
                        late String chatId;
                        if (response == 1) {
                          chatId = '$userId$friendId';
                        } else if (response == -1) {
                          chatId = '$friendId$userId';
                        }
                        debugPrint(chatId);
                        chatsController.fetchMessages(chatId);
                        // debugPrint('${chatsController.messagesWithUser}');
                        Get.back();
                        String friendName =
                            '${colleaguesController.colleaguesOnWorkSpace[index]['firstName']} ${colleaguesController.colleaguesOnWorkSpace[index]['lastName']}';
                        Get.to(() => const ChatMessages(), arguments: [
                          friendName,
                          chatId,
                          userId,
                          friendId,
                        ]);
                      },
                      child: const Text('Message'))
                  : const Text(''),
            ],
          );
        });
  }
}
