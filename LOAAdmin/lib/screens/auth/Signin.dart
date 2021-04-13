import 'package:LOAAdmin/screens.dart';
import 'package:LOAAdmin/screens/auth/Signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:toast/toast.dart';

class Signin extends StatefulWidget {
  Signin({Key key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool obscured = true;
  bool isLoading = false;
  dynamic data;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Container(
                      height: 80,
                      width: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/uew.png'),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 8,
                  ),
                  child: Text(
                    'Library Orientation App Admin',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _email,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      labelText: 'Email',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    obscureText: obscured,
                    controller: _password,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (obscured) {
                              obscured = false;
                            } else {
                              obscured = true;
                            }
                          });
                        },
                        icon: Icon(
                          obscured ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    color: Colors.blue,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        UserCredential user = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: _email.text,
                          password: _password.text,
                        );

                        if (user != null) {
                          // Get The Current Admin
                          User adminCurrent = FirebaseAuth.instance.currentUser;

                          // Get the admins collection from firestore
                          CollectionReference admins =
                              FirebaseFirestore.instance.collection('admins');

                          admins
                              .doc(adminCurrent.uid)
                              .get()
                              .then<dynamic>((snapshot) async {
                            setState(() {
                              data = snapshot.data();
                            });
                          });

                          if (data['role'] == 'Admin') {
                            // Navigate to Dashboard
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                              builder: (context) {
                                return Dashboard();
                              },
                            ), (Route<dynamic> route) => false);
                          } else {
                            Toast.show(
                              'Access denied.',
                              context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM,
                            );
                          }
                        }
                      } catch (e) {
                        print(e);
                        Toast.show(
                          '$e',
                          context,
                          duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        _email.text = '';
                        _password.text = '';
                      }
                    },
                    child: isLoading
                        ? NutsActivityIndicator(
                            activeColor: Colors.white,
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                          builder: (context) {
                            return Signup();
                          },
                        ), (Route<dynamic> route) => false);
                      },
                      child: Text('Sign Up'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ForgotPassword();
                            },
                          ),
                        );
                      },
                      child: Text('Forgot Password?'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
