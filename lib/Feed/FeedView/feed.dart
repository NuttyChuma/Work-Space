import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:get/get.dart';
import 'package:work_space/Feed/AddAnnouncement/add_announcement.dart';
import 'package:work_space/Feed/AddEvent/add_event.dart';
import 'package:work_space/Feed/FeedController/feed_controller.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool _isShowDial = false;

  // DatabaseReference ref = FirebaseDatabase.instance.ref("posts");
  //
  // ref.onChildAdded.listen((event) {
  //   debugPrint('hooray i am updated');
  //   debugPrint('hooray i am updated');
  // });
  final feedController = Get.find<FeedController>();

  @override
  Widget build(BuildContext context) {

    if(feedController.feed.isEmpty) {
      feedController.getFeed();
    }
    // debugPrint('${feedController.feed}');
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: Obx(() => RefreshIndicator(
        onRefresh: () => feedController.getFeed(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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
            if (feedController.feed.isEmpty)
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
                                        child: Text('${feedController.feed[index]['name'][0]}'),
                                      ),
                                      title: Text('${feedController.feed[index]['name']}'),
                                      trailing:
                                      const Icon(Icons.more_horiz_rounded),
                                    ),
                                    Container(
                                      height: 100.0,
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      child: Card(
                                        elevation: 0.1,
                                          color: Colors.deepPurple.shade100,
                                          child: Center(
                                            child: (feedController.feed[index]
                                            ['eventMessage'] !=
                                                null)
                                                ? Text(
                                                '${feedController.feed[index]['eventMessage']}')
                                                : Text(
                                                '${feedController.feed[index]['announcementMessage']}'),
                                          )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Card(
                                        elevation: 0.1,
                                        color: Colors.deepPurple.shade100,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                child: Text(
                                                    'Date & Time: ${feedController.feed[index]['dateAndTime']}')),

                                            (feedController.feed[index]['venue'] != null)? Container(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                child: Text(
                                                    'Location: ${feedController.feed[index]['venue']}')):const Text(""),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 10.0,
                              color: Colors.deepPurple.shade200,
                            ),
                          ],
                        ));
                  },
                  childCount: feedController.feed.length,
                ),
              ),
            SliverToBoxAdapter(
              child: Container(
                height: 300.0,
              ),
            ),
          ],
        ),
      )) ,
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
              Get.back();
              Get.to(()=> const AddEvent());
              setState(() {});
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
              _isShowDial = false;
              Get.to(()=>const AddAnnouncement());
              setState(() {});
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
