import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:work_space/Feed/AddAnnouncement/announcement_privacy.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AddAnnouncement extends StatefulWidget {
  const AddAnnouncement({Key? key}) : super(key: key);

  @override
  State<AddAnnouncement> createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  String dateMessage = 'YYYY-MM-DD HH:MM';
  String announcementMessage = '';

  submitEvent() async{
    var uuid = const Uuid();
    Map<String, dynamic> event = {
      'announcement': announcementMessage,
      'dateAndTime': dateMessage,
      'announcementId': uuid.v1(),
      'name': 'Liliane Weiner',
    };

    String uri = 'http://192.168.3.68:5000/';
    await http.post(Uri.parse("${uri}postAnnouncement"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(event));
    Navigator.pop(context);
    debugPrint(announcementMessage);
    debugPrint(dateMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.deepPurple.shade300,
            title: const Text('Add Announcement'),
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AnnouncementPrivacy()));
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text(
                      "Announcement Privacy",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                // offset: Offset(0, 100),
                color: Colors.deepPurple.shade300,
                elevation: 10.0,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                decoration: InputDecoration(
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
                      borderSide: BorderSide(color: Colors.deepPurple.shade900),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                onChanged: (message) {
                  announcementMessage = message;
                },
                minLines: 1,
                maxLines: 7,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            width: MediaQuery.of(context).size.width / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 59.5,
                  width: 170.0,
                  child: TextButton(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            onConfirm: (date) {
                          setState(() {
                            String dateTime = '$date';
                            dateMessage = dateTime.substring(0, 16);
                            debugPrint('confirm ${dateTime.substring(0, 16)}');
                          });
                        });
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.all(15)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: Colors.deepPurple.shade900)))),
                      child: Text(
                        dateMessage,
                        style: TextStyle(color: Colors.deepPurple.shade900),
                      )),
                ),
              ],
            ),
          )),
          SliverToBoxAdapter(
            child: Container(
              height: 50.0,
              margin: const EdgeInsets.symmetric(horizontal: 85.0),
              child: FloatingActionButton(
                backgroundColor: Colors.deepPurple.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                onPressed: () {
                  submitEvent();
                  //task to execute when this button is pressed
                },
                child: const ListTile(
                  title: Text(
                    'Post Announcement',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
