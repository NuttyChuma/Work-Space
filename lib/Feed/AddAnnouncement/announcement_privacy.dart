import 'package:flutter/material.dart';
import 'package:work_space/Feed/AddAnnouncement/share_announcement_with_all_departments_except.dart';
import 'package:work_space/Feed/AddAnnouncement/share_announcement_with_only.dart';

enum SingingCharacter { lafayette, jefferson, just }
class AnnouncementPrivacy extends StatefulWidget {
  const AnnouncementPrivacy({Key? key}) : super(key: key);

  @override
  State<AnnouncementPrivacy> createState() => _AnnouncementPrivacyState();
}

class _AnnouncementPrivacyState extends State<AnnouncementPrivacy> {

  SingingCharacter? _character = SingingCharacter.lafayette;
  dynamic globalValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple.shade300,
            title: const Text('Announcement Privacy'),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              child: const Text('Choose who can see this announcement'),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child:
              ListTile(
                title: const Text('All Departments'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.jefferson,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
                onTap: (){
                  setState(() {
                    _character = SingingCharacter.jefferson;
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child:  ListTile(
                title: const Text('All Departments Except...'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.lafayette,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      debugPrint("$value");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ShareAnnouncementWithAllDepartmentsExcept()));
                    });
                  },
                ),
                onTap: (){
                  setState((){
                    _character = SingingCharacter.lafayette;
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const ShareAnnouncementWithAllDepartmentsExcept()));
                  });
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child:  ListTile(
                title: const Text('Only Share With...'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.just,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ShareAnnouncementOnlyWith()));
                    });
                  },
                ),
                onTap: (){
                  setState((){
                    _character = SingingCharacter.just;
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const ShareAnnouncementOnlyWith()));
                  });

                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: const Text('NOTE: Changes applied now won\'t affect announcements you\'ve already posted'),
            ),
          ),
        ],
      ),
    );
  }
}
