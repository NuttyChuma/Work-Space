import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/Feed/AddAnnouncement/announcement_privacy.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:work_space/uri.dart';

import '../FeedController/feed_controller.dart';

class AddAnnouncement extends StatefulWidget {
  const AddAnnouncement({Key? key}) : super(key: key);

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  String dateMessage = 'YYYY-MM-DD HH:MM';
  String announcementMessage = '';
  double initialChildSize = 0.6;
  double minChildSize = 0.4;
  double maxChildSize = 0.95;

  final TextEditingController _controller = TextEditingController();

  late StreamSubscription<bool> _keyboardSubscription;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();

    _keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) async {
      if (visible) {
        initialChildSize = 0.95;
      } else {
        initialChildSize = 0.6;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _keyboardSubscription.cancel();
  }

  final feedController = Get.find<FeedController>();

  submitAnnouncement() async {
    Get.back();
    var uuid = const Uuid();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> event = {
      'announcement': announcementMessage,
      'dateAndTime': dateMessage,
      'announcementId': uuid.v1(),
      'name': preferences.getString('username')!,
    };

    await http.post(Uri.parse("${MyUri().uri}postAnnouncement"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(event));
    await feedController.getFeed();
  }

  @override
  Widget build(BuildContext context) {
    return makeDismissible(
      child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          builder: (_, controller) => Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20.0))),
                child: ListView(
                  controller: controller,
                  children: [
                    Align(
                      // alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () => showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                transitionDuration:
                                    const Duration(milliseconds: 500),
                                barrierLabel: MaterialLocalizations.of(context)
                                    .dialogLabel,
                                barrierColor: Colors.black.withOpacity(0.5),
                                pageBuilder: (context, _, __) {
                                  return const AnnouncementPrivacy();
                                },
                                transitionBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.fastOutSlowIn,
                                    ).drive(Tween<Offset>(
                                      begin: const Offset(0, -1.0),
                                      end: Offset.zero,
                                    )),
                                    child: child,
                                  );
                                },
                              ),
                          icon: const Icon(Icons.privacy_tip_outlined)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 20.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: 'announcement',
                          labelStyle: TextStyle(
                            color: Colors.deepPurple.shade900,
                          ),
                          isDense: false,
                          filled: true,
                          fillColor: Colors.white30,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.deepPurple.shade900),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onChanged: (message) {
                          announcementMessage = message;
                        },
                        minLines: 5,
                        maxLines: 7,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: SizedBox(
                        height: 59.5,
                        width: 170.0,
                        child: TextButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  onConfirm: (date) {
                                setState(() {
                                  String dateTime = '$date';
                                  dateMessage = dateTime.substring(0, 16);
                                  debugPrint(
                                      'confirm ${dateTime.substring(0, 16)}');
                                });
                              });
                            },
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color:
                                                Colors.deepPurple.shade900)))),
                            child: Text(
                              dateMessage,
                              style:
                                  TextStyle(color: Colors.deepPurple.shade900),
                            )),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(
                          top: 50.0, left: 10.0, right: 10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          announcementMessage = announcementMessage.trim();
                          if(announcementMessage.isNotEmpty){
                            submitAnnouncement();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepPurple),
                        ),
                        child: const Center(
                          child: Text(
                            'Post Announcement',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Get.back(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );
}
