import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/Chats/Controllers/chats_controller.dart';
import 'package:work_space/Chats/Views/colleagues.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final chatsController = Get.find<ChatsController>();
  late String userId = '';

  @override
  void initState() {
    getUserId();
    super.initState();
  }
  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString('userId')!;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
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
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
            ],
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              var key = chatsController.messages[index]['messages'].keys.elementAt(index);
              // debugPrint('${chatsController.messages[index]['messages'][key]['message']['user1']['userId']}');
              String chatName =
                  (chatsController.messages[index]['messages'][key]['message']['user1']['userId'] != userId)
                      ? chatsController.messages[index]['messages'][key]['message']['user1']['username']
                      : chatsController.messages[index]['messages'][key]['message']['user2']['username'];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade600,
                  child: Text(chatName[0]),
                ),
                title: Text(chatName),
                subtitle: const Text('some important busy people text'),
              );
            },
            childCount: chatsController.messages.length,
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const Colleagues());
          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Colleagues(colleagues)));
        },
        backgroundColor: Colors.deepPurple.shade600,
        child: const Icon(Icons.chat),
      ),
    );
  }
}
