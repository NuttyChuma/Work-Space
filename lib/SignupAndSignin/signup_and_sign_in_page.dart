import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../app.dart';

// Uri to the API
String uri = "http://192.168.3.68:5000/";

String? username, userEmail, department;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  @override
  void initState() {
    checkIfAlreadySignedIn();
    super.initState();
  }

  checkIfAlreadySignedIn() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? tmpUsername = sharedPreferences.getString('username');
    String? tmpUserEmail = sharedPreferences.getString('email');
    String? tmpUserDepartment = sharedPreferences.getString('department');

    debugPrint(tmpUsername);
    debugPrint(tmpUserEmail);
    debugPrint(tmpUserDepartment);

    if(tmpUsername != null && tmpUserEmail != null && tmpUserDepartment != null){
      goToApp();
    }
  }
  goToApp(){
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const App()),
            (Route<dynamic> route) => false);
  }

  Future<String?> _authUser(LoginData data) async {
    var result = await http.post(Uri.parse("${uri}login"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, String>{
          "email": data.name,
          "password": data.password,
        }));
    var json = jsonDecode(result.body);

    bool isSuccessful = json['isSuccessful'];
    Map<String, dynamic> userData ={};
    if(json['userData'] != null){
      userData = json['userData'];
    }
    if(!isSuccessful){
      return 'Email And Password Combination Does\'t match our database';
    }

    userEmail = userData['email'];
    username = '${userData['firstName']} ${userData['lastName']}';
    department = userData['department'];

    // debugPrint(username);
    // debugPrint(userEmail);
    // debugPrint(department);

    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');

    var uuid = const Uuid();
    var result = await http.post(Uri.parse("${uri}signup"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, String>{
          "email": data.name as String,
          "password": data.password as String,
          "uuid": uuid.v1(),
        }));
    var json = jsonDecode(result.body);
    debugPrint('$json');

    bool doesNotExist = json['doesNotExist'];
    bool alreadyExists = json['alreadyExists'];
    Map<String, dynamic> userData ={};
    if(json['userData'] != null){
      userData = json['userData'];
    }
    if(doesNotExist || alreadyExists){
      return 'User Does Not Work In The Company Or\nUser Already Exists';
    }

    userEmail = userData['email'];
    username = '${userData['firstName']} ${userData['lastName']}';
    department = userData['department'];

    // debugPrint(username);
    // debugPrint(userEmail);
    // debugPrint(department);

    return null;
  }

  Future<String?> _recoverPassword(String name) async {
    debugPrint('Name: $name');
    await http.post(Uri.parse("${uri}auth/reset/"),
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(<String, String>{
          "email": name,
        }));
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Work Space',
      theme: LoginTheme(
          primaryColor: Colors.deepPurple.shade300,
          accentColor: Colors.deepPurple.shade200,
          titleStyle: const TextStyle(color: Colors.white)),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () async{
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const App()),
              (Route<dynamic> route) => false);

          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString('username', username!);
          sharedPreferences.setString('email', userEmail!);
          sharedPreferences.setString('department', department!);

          debugPrint(sharedPreferences.getString('username'));
          debugPrint(sharedPreferences.getString('email'));
          debugPrint(sharedPreferences.getString('department'));
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        recoverPasswordDescription: "We will send a link to the email account.",
        recoverPasswordSuccess: 'If your account exists email has been sent!',
        additionalSignUpFormDescription:
            "Enter your username in this form to complete signup",
        signUpSuccess: "A verification link has been sent."
            "\nCHECK IN YOUR SPAM EMAILS TOO!!!",
      ),
    );
  }
}
//lweiner0@cam.ac.uk