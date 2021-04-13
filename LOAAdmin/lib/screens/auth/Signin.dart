import 'package:LOAAdmin/screens.dart';
import 'package:LOAAdmin/screens/auth/Signup.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  Signin({Key key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool obscured = true;
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
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      obscureText: obscured,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
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
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                        builder: (context) {
                          return Dashboard();
                        },
                      ), (Route<dynamic> route) => false);
                    },
                    child: Text(
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
