import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  final feedController = Get.find<FeedController>();

  @override
  Widget build(BuildContext context) {
    if (feedController.feed.isEmpty) {
      feedController.getFeed();
    }
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: Obx(() => RefreshIndicator(
            onRefresh: () => feedController.getFeed(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
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
                                            child: Text(
                                                '${feedController.feed[index]['name'][0]}'),
                                          ),
                                          title: Text(
                                              '${feedController.feed[index]['name']}'),
                                          trailing: const Icon(
                                              Icons.more_horiz_rounded),
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
                                                child: (feedController
                                                                .feed[index]
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10.0),
                                                    child: Text(
                                                        'Date & Time: ${feedController.feed[index]['dateAndTime']}')),
                                                (feedController.feed[index]
                                                            ['venue'] !=
                                                        null)
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10.0),
                                                        child: Text(
                                                            'Location: ${feedController.feed[index]['venue']}'))
                                                    : const Text(""),
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
          )),
      floatingActionButton: buildSpeedDial(),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      overlayColor: Colors.deepPurple.shade100,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 28.0),
      backgroundColor: Colors.deepPurple.shade700,
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.announcement_outlined, color: Colors.white),
          backgroundColor: Colors.deepPurple,
          onTap: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => const AddAnnouncement()),
          label: 'Add Announcement',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.deepPurple.shade500,
        ),
        SpeedDialChild(
          child: const Icon(Icons.event, color: Colors.white),
          backgroundColor: Colors.deepPurple,
          onTap: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => const AddEvent()),
          label: 'Add Event',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.deepPurple.shade500,
        ),
      ],
    );
  }
}