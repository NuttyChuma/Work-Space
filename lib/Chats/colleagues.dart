import 'package:flutter/material.dart';

class Colleagues extends StatefulWidget {
  final List? colleagues;
  const Colleagues(this.colleagues, {Key? key}) : super(key: key);

  @override
  State<Colleagues> createState() => _ColleaguesState();
}

class _ColleaguesState extends State<Colleagues> {
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
          (widget.colleagues != null)
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
                                      '${widget.colleagues![index]['firstName'][0]}'),
                                ),
                                title: Text(
                                    '${widget.colleagues![index]['firstName']} ${widget.colleagues![index]['lastName']}'),
                                subtitle: Text(
                                    'From ${widget.colleagues![index]['department']}'),
                                // trailing: const Icon(Icons.favorite_border),
                              ),
                              const Divider(
                                thickness: 2.0,
                              ),
                            ],
                          ));
                    },
                    childCount: widget.colleagues!.length,
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
    );
  }
}
