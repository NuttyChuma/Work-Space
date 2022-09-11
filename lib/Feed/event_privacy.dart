import 'package:flutter/material.dart';

enum SingingCharacter { lafayette, jefferson, just }
class EventPrivacy extends StatefulWidget {
  const EventPrivacy({Key? key}) : super(key: key);

  @override
  State<EventPrivacy> createState() => _EventPrivacyState();
}

class _EventPrivacyState extends State<EventPrivacy> {

  SingingCharacter? _character = SingingCharacter.lafayette;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurple.shade300,
            title: const Text('Event Privacy'),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: const Text('Choose who can see this event'),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child:
              ListTile(
                title: const Text('All Colleagues'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.jefferson,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child:  ListTile(
                title: const Text('All Colleagues Except...'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.lafayette,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
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
                    });
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: const Text('NOTE: Changes applied now won\'t affect events you\'ve already posted'),
            ),
          ),
        ],
      ),
    );
  }
}
