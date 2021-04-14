import 'package:LOAAdmin/screens/auth/Signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  _showDialog(BuildContext context) {
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Message'),
      content: Text('Do you really want to logout?'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text('Yes'),
          onPressed: () async {
            // SharedPreferences prefs = await SharedPreferences.getInstance();
            // prefs.getString('studentLevel');
            // prefs.getString('studentName');
            // prefs.getString('studentEmail');
            // prefs.getString('studentPassword');
            await FirebaseAuth.instance.signOut().then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => Signin(),
                ),
                (Route<dynamic> route) => false,
              );
            });
          },
        ),
      ],
    );

    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0.5,
          backgroundColor: Colors.white,
          title: Text(
            'My Account',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image(
              image: AssetImage('assets/images/uew.png'),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user.png'),
                    backgroundColor: Colors.grey,
                    radius: 35,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    onTap: () {
                      // Open Edit Profile
                    },
                    title: Center(
                      child: Text('Solomon Aidoo Junior'),
                    ),
                    subtitle: Center(
                      child: Text('aidoojuniorsolomon@gmail.com'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return ChangePassword();
                          //     },
                          //   ),
                          // );
                        },
                        leading: Icon(CupertinoIcons.padlock),
                        title: Text('Change Password'),
                        trailing: Icon(CupertinoIcons.forward),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 2,
                  margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          _showDialog(context);
                        },
                        leading: Icon(FontAwesomeIcons.signOutAlt),
                        title: Text('Logout'),
                        trailing: Icon(CupertinoIcons.forward),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
