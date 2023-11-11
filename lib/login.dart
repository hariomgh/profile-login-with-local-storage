import 'package:edu_kit_hariom/profile.dart';
import 'package:edu_kit_hariom/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF08d6cb),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0,20,0,0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  Text(
                    'Welcome! \n\nEnter your Details to Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey, // Added a GlobalKey for form validation
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.50,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _emailController,
                              // Added controller
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: 16),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your E-mail ID here';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: ' Email',
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.black,
                              width: 0.50,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(fontSize: 16),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password here';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: ' password ',
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 150),
                        Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff36e869), Color(0xFF08d6cb)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              _login();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 200,
                              child: Text(
                                'LOG-IN',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("don't have an account!"),
                            TextButton(onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SignUp()));
                            }, child: Text("Sign-up"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final prefs = await SharedPreferences.getInstance();
      final storedPassword = prefs.getString('password_$email');

      if (storedPassword == password) {
        String? userName = await prefs.getString('name_$email');
        String? userEmail = await prefs.getString('email');

        if (userName != null && userEmail != null) {
          // Set a flag indicating the user is logged in
          prefs.setBool('isLoggedIn', true);

          prefs.setString('loggedInUserEmail', userEmail);
          prefs.setString('loggedInUserName', userName);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Profile(userName: userName, userEmail: userEmail)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please check your credentials.'),
          ),
        );
      }
    }
  }

}
