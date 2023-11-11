import 'package:flutter/material.dart';
import 'package:edu_kit_hariom/login.dart';
import 'package:edu_kit_hariom/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Fetch user details from SharedPreferences
  String? userName = prefs.getString('loggedInUserName');
  String? userEmail = prefs.getString('loggedInUserEmail');
  String? userBio = prefs.getString('bio_$userName'); // Fetch bio from SharedPreferences
  String? userPin = prefs.getString('pin_$userName'); // Fetch pin code from SharedPreferences

  runApp(MyApp(isLoggedIn: isLoggedIn, userName: userName, userEmail: userEmail, userBio: userBio, userPin: userPin));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userName;
  final String? userEmail;
  final String? userBio;
  final String? userPin;

  const MyApp({Key? key, required this.isLoggedIn, this.userName, this.userEmail, this.userBio, this.userPin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isLoggedIn ? '/profile' : '/',
      routes: {
        '/': (context) => Login(),
        '/profile': (context) => Profile(
          userName: userName ?? '',
          userEmail: userEmail ?? '',
          userBio: userBio ?? '',
          userPin: userPin ?? '',
        ),
      },
    );
  }
}
