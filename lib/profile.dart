import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edu_kit_hariom/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';
import 'model.dart';

class Profile extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? userBio;
  final String? userPin;

  const Profile(
      {Key? key,
        required this.userName,
        required this.userEmail,
        this.userBio,
        this.userPin})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late PincodeData pincodeData = PincodeData(name: '', description: '', bio: '');

  @override
  void initState() {
    super.initState();
    fetchPincodeData('110001');
  }

  Future<void> fetchPincodeData(String postalCode) async {
    try {
      final data = await fetchPincode(postalCode);
      if (data != null) {
        setState(() {
          pincodeData = data;
        });
      }
    } catch (e) {
      print('Failed to fetch PIN code: $e');
    }
  }

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
          children: [
            Container(

              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/img.png"),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                  SizedBox(height: 20),
                  Text(
                    'Welcome, ${widget.userName}!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Emails: ${widget.userEmail}',
                    style: TextStyle(

                    ),
                  ),

                  SizedBox(height: 10),
                  Text('PIN Code: ${pincodeData.description}'),
                  SizedBox(height: 10),
                  Text('Bio: ${pincodeData.bio}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final updatedPincodeData = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfile(userName: widget.userName),
                        ),
                      );
                      if (updatedPincodeData != null) {
                        setState(() {
                          pincodeData = updatedPincodeData;
                        });
                      }
                    },
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    await prefs.remove('email');
    await prefs.remove('password_${widget.userName}');
    await prefs.remove('name_${widget.userName}');

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Login()));
  }
}

class PincodeData {
  final String name;
  final String description;
  final String bio;

  PincodeData(
      {required this.name, required this.description, required this.bio});
}

Future<PincodeData> fetchPincode(String postalCode) async {
  final url = 'http://www.postalpincode.in/api/pincode/$postalCode';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final postOffice = data[0]['PostOffice'][0];
    final name = postOffice['Name'];
    final description = postOffice['Description'];
    final bio = postOffice['Bio'];

    return PincodeData(name: name, description: description, bio: bio);
  } else {
    throw Exception('Failed to fetch PIN code');
  }
}
