import 'package:edu_kit_hariom/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model.dart';

class EditProfile extends StatefulWidget {
  final String userName;

  EditProfile({Key? key, required this.userName}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String updatedName = '';
  String updatedBio = '';
  String updatedPincode = '';
  bool isLoading = false;
  late String editedUserName; // Mutable variable to store the updated user name

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    editedUserName = widget.userName; // Initialize the mutable variable with the initial user name

    // Retrieve previously saved bio and pin
    _loadBioAndPin();
  }

  Future<void> _loadBioAndPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      updatedBio = prefs.getString('bio_${widget.userName}') ?? '';
      updatedPincode = prefs.getString('pin_${widget.userName}') ?? '';
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        isLoading = false;
        editedUserName = updatedName; // Update the mutable variable with the new user name
      });

      // Save the updated username to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('name_${widget.userName}', editedUserName);

      // Save the updated bio and pin to SharedPreferences
      prefs.setString('bio_${widget.userName}', updatedBio);
      prefs.setString('pin_${widget.userName}', updatedPincode);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff36e869),
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: <Widget>[
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("assets/images/img.png"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Edit Name:',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 300,
                      child: TextFormField(
                        initialValue: widget.userName,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            updatedName = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Bio',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 300,
                      child: TextFormField(
                        initialValue: updatedBio,
                        decoration: InputDecoration(
                          labelText: 'Bio',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            updatedBio = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Edit Pincode:',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 300,
                      child: TextFormField(
                        initialValue: updatedPincode,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Pincode',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            updatedPincode = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isLoading ? null : () async {
                        await _updateProfile();
                        Navigator.pop(context, PincodeData(name: editedUserName, description: updatedPincode, bio: updatedBio));
                      },
                      child: Text('Save Changes'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
