// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../Home/home.dart';
// import '../../SignupAndSignin/signup_and_sign_in_page.dart';
//
// Widget loginScreen = const LoginScreen();
//
// class MainController extends GetxController{
//
//   var nextScreen = loginScreen.obs;
//
//   Future<Widget> checkIfAlreadySignedIn() async{
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? tmpUsername = sharedPreferences.getString('username');
//     String? tmpUserEmail = sharedPreferences.getString('email');
//     String? tmpUserDepartment = sharedPreferences.getString('department');
//
//     debugPrint(tmpUsername);
//     debugPrint(tmpUserEmail);
//     debugPrint(tmpUserDepartment);
//
//     if(tmpUsername != null && tmpUserEmail != null && tmpUserDepartment != null){
//       nextScreen = const App() as Rx<Widget>;
//     }
//     return const LoginScreen();
//   }
// }