import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  TextEditingController _emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.back,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Recover Password',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Text(
                "Enter your email address associated with this app. We'll send you an email to enable you reset your password.",
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    // await FirebaseAuth.instance
                    //     .sendPasswordResetEmail(email: _emailController.text)
                    //     .then(
                    //       (value) => Navigator.of(context).pushAndRemoveUntil(
                    //           MaterialPageRoute(
                    //         builder: (context) {
                    //           return RecoveryEmailSent();
                    //         },
                    //       ), (Route<dynamic> route) => false),
                    //     )
                    //     .catchError((onError) {
                    //   setState(() {
                    //     isLoading = false;
                    //   });
                    // });
                  },
                  child: isLoading
                      ? CupertinoActivityIndicator()
                      : Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
