import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:work_space/Feed/add_event.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool _isShowDial = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: const Center(
        child: Text('Feed'),
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
            mini: true,
            onPressed: () {
              //if need to close menu after click
              _isShowDial = false;
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddEvent()));
              });
            },
            backgroundColor: Colors.deepPurple.shade900,
            child: const Icon(Icons.event),
          ),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              //if need to toggle menu after click
              _isShowDial = !_isShowDial;
              setState(() {});
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

  // Future addEventDialog() =>
  //     showDialog(context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text('Add Event'),
  //           content: TextField(
  //             decoration: InputDecoration(
  //               border:
  //             ),
  //           ),
  //           actions: [
  //             TextButton(onPressed: (){}, child: Text('Proceed'))
  //           ],
  //         ));
}
