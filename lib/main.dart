import 'dart:ui';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        nextScreen: const App(),
      ),
    );
  }
}