import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:edu_kit_hariom/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile.dart';

class Profile extends StatefulWidget {
  final String userName;

  const Profile({Key? key, required this.userName}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff36e869),
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${widget.userName}!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey,
              child: CachedNetworkImage(
                imageUrl:
                'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Test Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.userName,
              style: TextStyle(fontSize: 16),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfile(userName: widget.userName),
                  ),
                );
              },
              child: Text('Edit profile'),
            )

          ],
        ),
      ),
    );
  }

  // Function to perform logout
  void _logout(BuildContext context) async {
    // Clear user data from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email'); // Remove the email
    await prefs.remove('password_${widget.userName}'); // Remove the password
    await prefs.remove('name_${widget.userName}'); // Remove the username

    // Navigate back to the login page
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}
