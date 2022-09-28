import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:work_space/Feed/AddEvent/event_privacy.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../FeedController/feed_controller.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String dateMessage = 'YYYY-MM-DD HH:MM';

  String eventMessage = '';

  String venue = '';

  final feedController = Get.find<FeedController>();

  submitEvent() async{
    Get.back();
    debugPrint(venue);
    var uuid = const Uuid();
    Map<String, dynamic> event = {
      'event': eventMessage,
      'dateAndTime': dateMessage,
      'venue': venue,
      'eventId': uuid.v1(),
      'name': 'Liliane Weiner',
    };
    debugPrint(eventMessage);
    String uri = 'http://192.168.3.124:5000/';
    await http.post(Uri.parse("${uri}postEvent"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(event));
    await feedController.getFeed();
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
            actions: [
              PopupMenuButton(
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventPrivacy()));
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text(
                      "Event Privacy",
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
                  labelText: 'add event',
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
                  eventMessage = message;
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                    Container(
                      width: 180,
                      height: 60,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'add venue',
                          labelStyle: TextStyle(
                            color: Colors.deepPurple.shade900,
                          ),
                          isDense: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Colors.deepPurple.shade900, width: 20),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.deepPurple.shade900),
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onChanged: (nVenue) {
                          venue = nVenue;
                        },
                        minLines: 1,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              )),
          SliverToBoxAdapter(
            child: Container(
              height: 50.0,
              margin: const EdgeInsets.symmetric(horizontal: 120.0),
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
                    'Post Event',
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
