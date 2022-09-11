import 'package:flutter/material.dart';
import 'package:work_space/Feed/event_privacy.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
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
                onSelected: (value){
                  if (value == 1){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const EventPrivacy()));
                  }
                },
                itemBuilder: (context) => [
                   const PopupMenuItem(
                    value: 1,
                    child: Text("Event Privacy", style: TextStyle(color: Colors.white),),
                  ),
                ],
                // offset: Offset(0, 100),
                color: Colors.deepPurple.shade300,
                elevation: 10.0,
              ),
            ],
          ),
          SliverToBoxAdapter (
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'add event',
                    labelStyle: TextStyle(
                      color: Colors.deepPurple.shade900,
                      // fontSize: 20.0
                    ),
                    isDense: false,
                    filled: true,
                    fillColor: Colors.white30,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple.shade900),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                  ),
                  minLines: 1,
                  maxLines: 7,
                )),
          ),
          SliverToBoxAdapter(
            child: Container(

            ),
          )
        ],
      ),
    );
  }
}
