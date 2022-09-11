import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Colleagues extends StatefulWidget {
  const Colleagues({Key? key}) : super(key: key);

  @override
  State<Colleagues> createState() => _ColleaguesState();
}

class _ColleaguesState extends State<Colleagues> {
  @override
  void initState() {
    getChats();
    super.initState();
  }

  List? colleagues;

  getChats() async {
    String uri = 'http://192.168.3.68:5000/';
    var result = await http
        .get(Uri.parse('${uri}getAllChats'), headers: <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    });
    var json = jsonDecode(result.body).toList()[2]['department'];
    colleagues = jsonDecode(result.body).toList();
    setState(() {});
    debugPrint(json);
    // debugPrint('${length.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple.shade300,
            floating: true,
            pinned: true,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Colleagues'),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
            ],
          ),
          (colleagues != null)
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
                                      '${colleagues![index]['firstName'][0]}'),
                                ),
                                title: Text(
                                    '${colleagues![index]['firstName']} ${colleagues![index]['lastName']}'),
                                subtitle: Text(
                                    'From ${colleagues![index]['department']}'),
                                // trailing: const Icon(Icons.favorite_border),
                              ),
                              const Divider(
                                thickness: 2.0,
                              ),
                            ],
                          ));
                    },
                    childCount: colleagues!.length,
                  ),
                )
              : SliverToBoxAdapter(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple.shade600,
                        ),
                      )))
        ],
      ),
    );
  }
}
