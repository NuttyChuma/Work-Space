import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  // dynamic globalValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
          color: Colors.deepPurple.shade50,
          child: Card(
            color: Colors.deepPurple.shade100,
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Announcement Privacy',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: const Text('Choose who can see this announcement'),
                ),
                Container(
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
                Container(
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child:  ListTile(
                    title: const Text('Only Share With...'),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.just,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                          Get.to(()=>const ShareAnnouncementOnlyWith());
                        });
                      },
                    ),
                    onTap: (){
                      setState((){
                        _character = SingingCharacter.just;
                        Get.to(()=>const ShareAnnouncementOnlyWith());
                      });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 50.0),
                  // color: Colors.red,
                  child: const Text('NOTE: Changes applied now won\'t affect announcements you\'ve already posted'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
