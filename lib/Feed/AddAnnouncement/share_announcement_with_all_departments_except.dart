import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/uri.dart';

class ShareAnnouncementWithAllDepartmentsExcept extends StatefulWidget {
  const ShareAnnouncementWithAllDepartmentsExcept({Key? key}) : super(key: key);

  @override
  State<ShareAnnouncementWithAllDepartmentsExcept> createState() =>
      _ShareAnnouncementWithAllDepartmentsExceptState();
}

class _ShareAnnouncementWithAllDepartmentsExceptState
    extends State<ShareAnnouncementWithAllDepartmentsExcept> {
  @override
  void initState() {
    getDepartments();
    super.initState();
  }

  List? departments;
  List? announcementDepartmentsHiddenFromList = [];
  List? initialAnnouncementDepartmentsHiddenFromList;
  String? departmentsExcluded;

  getDepartments() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = await http.get(Uri.parse('${MyUri().uri}getAllDepartments'),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        });
    var hiddenDepartments = await http.post(
        Uri.parse('${MyUri().uri}announcementDepartmentsHiddenFromList'),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(
            <String, String>{'userId': preferences.getString('userId')!}));

    departments = jsonDecode(result.body).toList();
    announcementDepartmentsHiddenFromList =
        jsonDecode(hiddenDepartments.body).toList();
    initialAnnouncementDepartmentsHiddenFromList =
        List<String>.from(announcementDepartmentsHiddenFromList!);
    if (announcementDepartmentsHiddenFromList!.isNotEmpty) {
      departmentsExcluded =
          '${announcementDepartmentsHiddenFromList!.length} departments excluded';
    } else {
      departmentsExcluded = 'No departments excluded';
    }
    setState(() {});
  }

  updateHiddenDepartmentsList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await http.post(
        Uri.parse("${MyUri().uri}updateAnnouncementDepartmentsHiddenFromList"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, dynamic>{
          "announcementDepartmentsHiddenFromList":
              announcementDepartmentsHiddenFromList,
          "userIndex": preferences.getString('userId')!,
        }));
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
                  'Hide announcement from...',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
                subtitle: (departmentsExcluded != null)
                    ? Text(
                        departmentsExcluded!,
                        style: const TextStyle(color: Colors.white),
                      )
                    : const Text(''),
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
                                      (!announcementDepartmentsHiddenFromList!
                                              .contains(departments![index]))
                                          ? const Icon(
                                              Icons.circle_outlined,
                                              size: 27,
                                            )
                                          : Icon(
                                              Icons.check_circle,
                                              color: Colors.deepPurple.shade900,
                                            ),
                                  onTap: () {
                                    setState(() {
                                      if (announcementDepartmentsHiddenFromList!
                                          .contains(departments![index])) {
                                        announcementDepartmentsHiddenFromList!
                                            .remove(departments![index]);
                                      } else {
                                        announcementDepartmentsHiddenFromList!
                                            .add(departments![index]);
                                      }
                                      if (announcementDepartmentsHiddenFromList!
                                          .isNotEmpty) {
                                        departmentsExcluded =
                                            '${announcementDepartmentsHiddenFromList!.length} departments excluded';
                                      } else {
                                        departmentsExcluded =
                                            'No departments excluded';
                                      }
                                    });
                                  },
                                  // trailing: Icon(Icons.check_circle, color: Colors.red.shade300, size: 27,),
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
            const SliverToBoxAdapter(
              child: ListTile(
                title: Text(""),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade600,
          elevation: 0.0,
          onPressed: () {
            updateHiddenDepartmentsList();
            Navigator.pop(context);
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
    for (String department in initialAnnouncementDepartmentsHiddenFromList!) {
      if (!announcementDepartmentsHiddenFromList!.contains(department)) {
        changes = true;
      }
    }
    for (String department in announcementDepartmentsHiddenFromList!) {
      if (!initialAnnouncementDepartmentsHiddenFromList!.contains(department)) {
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
