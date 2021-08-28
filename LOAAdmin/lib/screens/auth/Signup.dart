import 'package:LOAAdmin/screens.dart';
import 'package:LOAAdmin/screens/auth/Signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:toast/toast.dart';

class Signup extends StatefulWidget {
  Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool obscured = true;
  bool isLoading = false;
  bool _firstValidate = false;
  bool _lastValidate = false;
  bool _emailValidate = false;
  bool _positionValidate = false;
  bool _passwordValidate = false;
  TextEditingController _firstname = new TextEditingController();
  TextEditingController _lastname = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _position = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      height: 70,
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
                  'Signup',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _firstname,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _firstValidate = false;
                        });
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
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
                      labelText: 'Firstname',
                      errorText: _firstValidate
                          ? 'Firstname field cannot be empty'
                          : null,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _lastname,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _lastValidate = false;
                        });
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
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
                      labelText: 'Lastname',
                      errorText: _lastValidate
                          ? 'Lastname field cannot be empty'
                          : null,
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _emailValidate = false;
                        });
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
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
                      errorText:
                          _emailValidate ? 'Email field cannot be empty' : null,
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _position,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _positionValidate = false;
                        });
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
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
                      labelText: 'Position',
                      errorText: _positionValidate
                          ? 'Position field cannot be empty'
                          : null,
                      prefixIcon: Icon(Icons.work_rounded),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _password,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _passwordValidate = false;
                        });
                      }
                    },
                    obscureText: obscured,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp('[ ]'),
                      ),
                    ],
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
                      errorText: _passwordValidate
                          ? 'Password field cannot be empty'
                          : null,
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
                      if (_firstname.text.isEmpty) {
                        setState(() {
                          _firstValidate = true;
                        });
                      } else if (_lastname.text.isEmpty) {
                        setState(() {
                          _lastValidate = true;
                        });
                      } else if (_email.text.isEmpty) {
                        setState(() {
                          _emailValidate = true;
                        });
                      } else if (_position.text.isEmpty) {
                        setState(() {
                          _positionValidate = true;
                        });
                      } else if (_password.text.isEmpty) {
                        setState(() {
                          _passwordValidate = true;
                        });
                      } else {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          UserCredential user = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: _email.text,
                            password: _password.text,
                          );

                          if (user != null) {
                            // Get The Current Admin
                            User adminCurrent =
                                FirebaseAuth.instance.currentUser;

                            // Save the user details into the database
                            FirebaseFirestore.instance
                                .collection('admins')
                                .doc(adminCurrent.uid)
                                .set({
                              'firstName': _firstname.text,
                              'lastName': _lastname.text,
                              'email': _email.text,
                              'position': _position.text,
                              'role': 'Admin'
                            });
                            await prefs.setString(
                              'adminName',
                              _firstname.text + ' ' + _lastname.text,
                            );
                            await prefs.setString(
                              'adminEmail',
                              _email.text,
                            );
                            User signInUser = FirebaseAuth.instance.currentUser;
                            signInUser.sendEmailVerification().then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                builder: (context) {
                                  return Dashboard();
                                },
                              ), (Route<dynamic> route) => false);
                            }).catchError((onError) {
                              print(onError);
                            });
                          }
                        } catch (e) {
                          SweetAlert.show(
                            context,
                            title: 'Error!',
                            subtitle: 'A signup error occured',
                            style: SweetAlertStyle.error,
                          );
                          setState(() {
                            isLoading = false;
                          });
                          _firstname.text = '';
                          _lastname.text = '';
                          _email.text = '';
                          _position.text = '';
                          _password.text = '';
                        }
                      }
                    },
                    child: isLoading
                        ? NutsActivityIndicator(
                            activeColor: Colors.white,
                          )
                        : Text(
                            'Signup',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                          builder: (context) {
                            return Signin();
                          },
                        ), (Route<dynamic> route) => false);
                      },
                      child: Text('Have an account? Sign In'),
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
