import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../Chats/Views/chats_view.dart';
import '../Feed/FeedView/feed.dart';
import '../Profile/profile.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int tabIndex = 0;
  _navigate(int index){
    setState(() {
      tabIndex = index;
    });
  }
  
  final List<Widget> pages = [const Chats(), const Feed(), const Profile()];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurple.shade100,
        color: Colors.deepPurple.shade300,
        animationDuration: const Duration(milliseconds: 300),
        onTap: _navigate,
        items: const [
          Icon(Icons.chat_bubble),
          Icon(Icons.feed),
          Icon(Icons.person),
        ],
      ),
      body: pages.elementAt(tabIndex),
    );
  }
}
