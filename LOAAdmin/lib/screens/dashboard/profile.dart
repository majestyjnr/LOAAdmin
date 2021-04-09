import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                    title: Text('Solomon Aidoo Junior'),
                    subtitle: Text('aidoojuniorsolomon@gmail.com'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 4,
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
              ],
            ),
          ),
        ));
  }
}
