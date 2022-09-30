import 'dart:ui';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_space/Chats/Controllers/chats_controller.dart';
import 'package:work_space/Chats/Controllers/colleagues_controller.dart';
import '../../Feed/FeedController/feed_controller.dart';
import '../../SignupAndSignin/signup_and_sign_in_page.dart';
import '../../FirebaseAndData/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(FeedController());
  final colleaguesController = Get.put(ColleaguesController());
  colleaguesController.getChats();

  final chatsController = Get.put(ChatsController());
  chatsController.getMessages();
  chatsController.listenToDatabase();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wits Services',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        duration: 1000,
        splashIconSize: window.physicalSize.width-100,
        animationDuration: const Duration(milliseconds: 1000),
        splashTransition: SplashTransition.slideTransition,
        backgroundColor: Colors.deepPurple.shade400,
        splash: const Center(child: Text('Work Space'),),
        nextScreen: const LoginScreen(),
      ),
    );
  }
}