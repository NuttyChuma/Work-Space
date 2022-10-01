import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/uri.dart';

class ShareWithOnly extends StatefulWidget {
  const ShareWithOnly({Key? key}) : super(key: key);

  @override
  State<ShareWithOnly> createState() => _ShareWithOnlyState();
}

class _ShareWithOnlyState extends State<ShareWithOnly> {
  @override
  void initState() {
    getDepartments();
    super.initState();
  }

  List? departments;
  List? departmentsSharedWithList = [];
  String? departmentsSelected;

  getDepartments() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var result = await http.get(Uri.parse('${MyUri().uri}getAllDepartments'),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        });

    var departmentsSharedWith = await http.post(
        Uri.parse('${MyUri().uri}departmentsSharedWithList'),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(
            <String, String>{'userId': preferences.getString('userId')!}));

    departments = jsonDecode(result.body).toList();
    departmentsSharedWithList = jsonDecode(departmentsSharedWith.body).toList();
    if (departmentsSharedWithList!.isNotEmpty) {
      departmentsSelected =
          '${departmentsSharedWithList!.length} departments selected';
    } else {
      departmentsSelected = 'No departments selected';
    }
    setState(() {});
  }

  updateDepartmentsSharedWithList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await http.post(Uri.parse("${MyUri().uri}updateDepartmentsSharedWithList"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, dynamic>{
          "departmentsSharedWithList": departmentsSharedWithList,
          "userIndex": preferences.getString('userId')!,
        }));
    if (departmentsSharedWithList!.isNotEmpty) {
      departmentsSelected =
          '${departmentsSharedWithList!.length} departments selected';
    } else {
      departmentsSelected = 'No departments selected';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple.shade300,
            floating: true,
            pinned: true,
            title: ListTile(
              title: const Text(
                'Only share event with...',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
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
                                trailing: (!departmentsSharedWithList!
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
                                    if (departmentsSharedWithList!
                                        .contains(departments![index])) {
                                      departmentsSharedWithList!
                                          .remove(departments![index]);
                                    } else {
                                      departmentsSharedWithList!
                                          .add(departments![index]);
                                    }
                                    if (departmentsSharedWithList!.isNotEmpty) {
                                      departmentsSelected =
                                          '${departmentsSharedWithList!.length} departments selected';
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
          updateDepartmentsSharedWithList();
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.check_rounded,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
