import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:work_space/Feed/AddAnnouncement/add_announcement.dart';
import 'package:work_space/Feed/AddEvent/add_event.dart';
import 'package:http/http.dart' as http;

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool _isShowDial = false;

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("posts");

    ref.onChildAdded.listen((event) {
      debugPrint('hooray i am updated');
      getFeed();
      debugPrint('hooray i am updated');
    });
    // ref.onChildChanged.listen((event) {
    //   debugPrint('hooray i am updated');
    //   getFeed();
    //   debugPrint('hooray i am updated');
    // });
    // ref.onValue.listen((event) {
    //   debugPrint('hooray i am updated');
    //   getFeed();
    //   debugPrint('hooray i am updated');
    // });
    // ref.onChildMoved.listen((event) {
    //   debugPrint('hooray i am updated');
    //   getFeed();
    //   debugPrint('hooray i am updated');
    // });
    // ref.onChildRemoved.listen((event) {
    //   debugPrint('hooray i am updated');
    //   getFeed();
    //   debugPrint('hooray i am updated');
    // });

    ref.set({
      'hjhvmhv': {
        'hjj': 'hjvjhv',
        'gcgc': 'jhvhv',
      }
    });

    getFeed();
    super.initState();
  }

  List? feed;

  getFeed() async {
    String uri = 'http://192.168.3.68:5000/';
    var result = await http
        .get(Uri.parse('${uri}getAllPosts'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    });

    feed = jsonDecode(result.body).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple.shade300,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Feed'),
            ),
            centerTitle: true,
            floating: true,
            pinned: true,
            expandedHeight: 100.0,
            excludeHeaderSemantics: true,
          ),
          if (feed == null)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                      color: Colors.deepPurple.shade100,
                      child: Column(
                        children: [
                          Container(
                            height: 200.0,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Card(
                              color: Colors.deepPurple.shade100,
                              elevation: 10.0,
                            ),
                          ),
                          const Divider(
                            thickness: 10.0,
                          ),
                        ],
                      ));
                },
                childCount: 3,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                      color: Colors.deepPurple.shade100,
                      child: Column(
                        children: [
                          Container(
                            // height: 250.0,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Card(
                              color: Colors.deepPurple.shade100,
                              elevation: 0.0,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Colors.deepPurple.shade600,
                                      child: Text('${feed![index]['name'][0]}'),
                                    ),
                                    title: Text('${feed![index]['name']}'),
                                    trailing:
                                        const Icon(Icons.more_horiz_rounded),
                                  ),
                                  Container(
                                    height: 100.0,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 5.0),
                                    child: Card(
                                        color: Colors.deepPurple.shade100,
                                        child: Center(
                                          child: (feed![index]
                                                      ['eventMessage'] !=
                                                  null)
                                              ? Text(
                                                  '${feed![index]['eventMessage']}')
                                              : Text(
                                                  '${feed![index]['announcementMessage']}'),
                                        )),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Card(
                                      color: Colors.deepPurple.shade100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                child: Text(
                                                    'Date & Time: ${feed![index]['dateAndTime']}')),
                                          ),
                                          (feed![index]['venue'] != null)? Expanded(
                                            flex: 1,
                                            child:Container(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                child: Text(
                                                    'Location: ${feed![index]['venue']}')),
                                          ):const Text(""),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 10.0,
                          ),
                        ],
                      ));
                },
                childCount: feed!.length,
              ),
            ),
          SliverToBoxAdapter(
            child: Container(
              height: 300.0,
            ),
          )
        ],
      ),
      floatingActionButton: SpeedDialMenuButton(
        isEnableAnimation: true,
        //if needed to close the menu after clicking sub-FAB
        isShowSpeedDial: _isShowDial,
        //manually open or close menu
        updateSpeedDialStatus: (isShow) {
          //return any open or close change within the widget
          _isShowDial = isShow;
        },
        //general init
        isMainFABMini: false,
        mainMenuFloatingActionButton: MainMenuFloatingActionButton(
            backgroundColor: Colors.deepPurple.shade600,
            mini: false,
            child: const Icon(Icons.add),
            onPressed: () {},
            closeMenuChild: const Icon(Icons.close),
            closeMenuForegroundColor: Colors.white,
            closeMenuBackgroundColor: Colors.deepPurple.shade600),
        floatingActionButtonWidgetChildren: <FloatingActionButton>[
          FloatingActionButton(
            heroTag: 'addEvent',
            mini: true,
            onPressed: () async {
              //if need to close menu after click
              _isShowDial = false;
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddEvent()));
              // getFeed();
            },
            backgroundColor: Colors.deepPurple.shade900,
            child: const Icon(Icons.event),
          ),
          FloatingActionButton(
            heroTag: 'addAnnouncement',
            mini: true,
            onPressed: () async {
              //if need to toggle menu after click
              _isShowDial = !_isShowDial;
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddAnnouncement()));
              // getFeed();
            },
            backgroundColor: Colors.deepPurple.shade900,
            child: const Icon(Icons.announcement),
          ),
        ],
        isSpeedDialFABsMini: false,
        paddingBtwSpeedDialButton: 50.0,
      ),
    );
  }
}
