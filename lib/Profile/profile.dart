import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_space/SignupAndSignin/signup_and_sign_in_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      body: Center(child: TextButton(onPressed: () async{
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Get.offAll(const LoginScreen());
      }, child: const Text('Logout')),),
    );
  }
}






















