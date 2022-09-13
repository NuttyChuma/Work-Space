import 'package:flutter/material.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple.shade300,
            leading: CircleAvatar(backgroundColor: Colors.deepPurple.shade600,radius: 5.0,child: const Text('C'),),
            title: const Text('Chat Name'),
            actions: const [
              Icon(Icons.more_vert_rounded)
            ],
            pinned: true,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: 20,
                     itemBuilder: (BuildContext context, int index) {
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
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextField(
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        hintText: 'Message',
                      ),
                    ),
                  ],
                )
              ],
            ),
          )


        ],
      ),
    );
  }
}
