import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List? departmentsSharedWithList = [''];

  getDepartments() async {
    String uri = 'http://192.168.3.68:5000/';
    var result = await http
        .get(Uri.parse('${uri}getAllDepartments'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    });
    // var departmentsSharedWith = await http
    //     .get(Uri.parse('${uri}departmentsSharedWithList'), headers: <String, String>{
    //   "Accept": "application/json",
    //   "Content-Type": "application/json; charset=UTF-8",
    // });
    //
    departments = jsonDecode(result.body).toList();
    // departmentsSharedWithList = jsonDecode(departmentsSharedWith.body).toList();
    setState(() {});
  }

  getDepartmentsSharedWithList() async{
    String uri = 'http://192.168.3.68:5000/';
    await http.post(Uri.parse("${uri}updateHiddenDepartmentsList"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, dynamic>{
          "departmentsSharedWithList": departmentsSharedWithList,
          "userIndex": 0,
        }));
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
            title: const ListTile(
              title: Text('Only share event with...', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),),
              subtitle: Text('No departments selected', style: TextStyle(color: Colors.white),),
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
                          trailing: (!departmentsSharedWithList!.contains(departments![index]))? const Icon(Icons.circle_outlined, size: 27,):const Icon(Icons.check_circle),
                          onTap: (){
                            setState(() {
                              if(departmentsSharedWithList!.contains(departments![index])){
                                departmentsSharedWithList!.remove(departments![index]);
                              }else{
                                departmentsSharedWithList!.add(departments![index]);
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
              ),),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade500,
        elevation: 0.0,
        onPressed: (){
          getDepartmentsSharedWithList();
          Navigator.pop(context);
        },
        child: const Icon(Icons.check_rounded, size: 30, color: Colors.white,),

      ),
    );
  }
}
