import 'package:flutter/material.dart';
import 'package:work_space/Chats/colleagues.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade600,
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
          SliverList(
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Colleagues()));
        },
        backgroundColor: Colors.deepPurple.shade600,
        child: const Icon(Icons.chat),
      ),
    );
  }
}
