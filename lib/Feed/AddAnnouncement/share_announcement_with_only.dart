import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/uri.dart';

class ShareAnnouncementOnlyWith extends StatefulWidget {
  const ShareAnnouncementOnlyWith({Key? key}) : super(key: key);

  @override
  State<ShareAnnouncementOnlyWith> createState() =>
      _ShareAnnouncementOnlyWithState();
}

class _ShareAnnouncementOnlyWithState extends State<ShareAnnouncementOnlyWith> {
  @override
  void initState() {
    getDepartments();
    super.initState();
  }

  List? departments;
  List? announcementDepartmentsSharedWithList = [];
  List? initialAnnouncementDepartmentsSharedWithList;
  String? departmentsSelected;

  getDepartments() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = await http.get(Uri.parse('${MyUri().uri}getAllDepartments'),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        });
    var departmentsSharedWith = await http.post(
        Uri.parse('${MyUri().uri}announcementDepartmentsSharedWithList'),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(
            <String, String>{'userId': preferences.getString('userId')!}));

    departments = jsonDecode(result.body).toList();
    announcementDepartmentsSharedWithList =
        jsonDecode(departmentsSharedWith.body).toList();
    initialAnnouncementDepartmentsSharedWithList =
        List<String>.from(announcementDepartmentsSharedWithList!);
    if (announcementDepartmentsSharedWithList!.isNotEmpty) {
      departmentsSelected =
          '${announcementDepartmentsSharedWithList!.length} departments selected';
    } else {
      departmentsSelected = 'No departments selected';
    }
    setState(() {});
  }

  updateDepartmentsSharedWithList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await http.post(
        Uri.parse("${MyUri().uri}updateAnnouncementDepartmentsSharedWithList"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, dynamic>{
          "announcementDepartmentsSharedWithList":
              announcementDepartmentsSharedWithList,
          "userIndex": preferences.getString('userId')!,
        }));
    if (announcementDepartmentsSharedWithList!.isNotEmpty) {
      departmentsSelected =
          '${announcementDepartmentsSharedWithList!.length} departments selected';
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
                title: const Text(
                  'Only share announcement with...',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
                subtitle: (departmentsSelected != null)
                    ? Text(
                        departmentsSelected!,
                        style: const TextStyle(color: Colors.white),
                      )
                    : const Text(""),
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
                                    child: Text('${departments![index][0]}'),
                                  ),
                                  title: Text('${departments![index]}'),
                                  trailing:
                                      (!announcementDepartmentsSharedWithList!
                                              .contains(departments![index]))
                                          ? const Icon(
                                              Icons.circle_outlined,
                                              size: 27,
                                            )
                                          : Icon(Icons.check_circle,
                                          color: Colors.deepPurple.shade900
                                      ),
                                  onTap: () {
                                    setState(() {
                                      if (announcementDepartmentsSharedWithList!
                                          .contains(departments![index])) {
                                        announcementDepartmentsSharedWithList!
                                            .remove(departments![index]);
                                      } else {
                                        announcementDepartmentsSharedWithList!
                                            .add(departments![index]);
                                      }
                                      if (announcementDepartmentsSharedWithList!
                                          .isNotEmpty) {
                                        departmentsSelected =
                                            '${announcementDepartmentsSharedWithList!.length} departments selected';
                                      } else {
                                        departmentsSelected =
                                            'No departments selected';
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
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple.shade600,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade600,
          elevation: 0.0,
          onPressed: () {
            updateDepartmentsSharedWithList();
            Get.back();
          },
          child: const Icon(
            Icons.check_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future? openDialog() {
    bool changes = false;
    for (String department in initialAnnouncementDepartmentsSharedWithList!) {
      if (!announcementDepartmentsSharedWithList!.contains(department)) {
        changes = true;
      }
    }
    for (String department in announcementDepartmentsSharedWithList!) {
      if (!initialAnnouncementDepartmentsSharedWithList!.contains(department)) {
        changes = true;
      }
    }
    if (changes) {
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
                    Get.back();
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
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
