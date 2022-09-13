import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShareAnnouncementOnlyWith extends StatefulWidget {
  const ShareAnnouncementOnlyWith({Key? key}) : super(key: key);

  @override
  State<ShareAnnouncementOnlyWith> createState() => _ShareAnnouncementOnlyWithState();
}

class _ShareAnnouncementOnlyWithState extends State<ShareAnnouncementOnlyWith> {
  @override
  void initState() {
    getDepartments();
    super.initState();
  }

  List? departments;
  List? announcementDepartmentsSharedWithList;
  List? initialAnnouncementDepartmentsSharedWithList;
  String? departmentsSelected;

  getDepartments() async {
    String uri = 'http://192.168.3.68:5000/';
    var result = await http
        .get(Uri.parse('${uri}getAllDepartments'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    });
    var departmentsSharedWith = await http
        .get(
        Uri.parse('${uri}announcementDepartmentsSharedWithList'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    });

    departments = jsonDecode(result.body).toList();
    announcementDepartmentsSharedWithList = jsonDecode(departmentsSharedWith.body).toList();
    initialAnnouncementDepartmentsSharedWithList = List<String>.from(announcementDepartmentsSharedWithList!);
    if (announcementDepartmentsSharedWithList!.length > 1) {
      departmentsSelected =
      '${announcementDepartmentsSharedWithList!.length - 1} departments selected';
    } else {
      departmentsSelected = 'No departments selected';
    }
    setState(() {});
  }

  updateDepartmentsSharedWithList() async {
    String uri = 'http://192.168.3.68:5000/';
    await http.post(Uri.parse("${uri}updateAnnouncementDepartmentsSharedWithList"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, dynamic>{
          "announcementDepartmentsSharedWithList": announcementDepartmentsSharedWithList,
          "userIndex": 0,
        }));
    if (announcementDepartmentsSharedWithList!.length > 1) {
      departmentsSelected =
      '${announcementDepartmentsSharedWithList!.length - 1} departments selected';
    } else {
      departmentsSelected = 'No departments selected';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        openDialog();
        return Future(() => true);
      },
      child: Scaffold(
        backgroundColor: Colors.deepPurple.shade100,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.deepPurple.shade300,
              floating: true,
              pinned: true,
              title: ListTile(
                title: const Text('Only share announcement with...', style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.white),),
                subtitle: (departmentsSelected != null) ? Text(
                  departmentsSelected!,
                  style: const TextStyle(color: Colors.white),):
                    const Text(""),
              ),

            ),
            (departments != null)
                ? SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Container(
                    // height: 60.0,
                      color: Colors.deepPurple.shade100,
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.deepPurple.shade600,
                              child: Text(
                                  '${departments![index][0]}'),
                            ),
                            title: Text(
                                '${departments![index]}'),
                            trailing: (!announcementDepartmentsSharedWithList!.contains(
                                departments![index])) ? const Icon(
                              Icons.circle_outlined, size: 27,) : const Icon(
                                Icons.check_circle),
                            onTap: () {
                              setState(() {
                                if (announcementDepartmentsSharedWithList!.contains(
                                    departments![index])) {
                                  announcementDepartmentsSharedWithList!.remove(
                                      departments![index]);
                                } else {
                                  announcementDepartmentsSharedWithList!.add(
                                      departments![index]);
                                }
                                if (announcementDepartmentsSharedWithList!.length > 1) {
                                  departmentsSelected =
                                  '${announcementDepartmentsSharedWithList!.length -
                                      1} departments selected';
                                } else {
                                  departmentsSelected = 'No departments selected';
                                }
                              });
                            },
                          ),
                          const Divider(
                            thickness: 2.0,
                          ),
                        ],
                      ));
                },
                childCount: departments!.length,
              ),
            )
                : SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple.shade600,
                  ),
                ),),),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green.shade500,
          elevation: 0.0,
          onPressed: () {
            updateDepartmentsSharedWithList();
            Navigator.pop(context);
          },
          child: const Icon(Icons.check_rounded, size: 30, color: Colors.white,),

        ),
      ),
    );
  }
  Future? openDialog() {
    bool changes = false;
    for(String department in initialAnnouncementDepartmentsSharedWithList!){
      if(!announcementDepartmentsSharedWithList!.contains(department)){
        changes = true;
      }
    }
    for(String department in announcementDepartmentsSharedWithList!){
      if(!initialAnnouncementDepartmentsSharedWithList!.contains(department)){
        changes = true;
      }
    }
    if(changes){
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple.shade300,
            content: const Text(
              'Discard Changes?',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'DISCARD',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          );
        },
      );
    }
    return null;
  }
}
