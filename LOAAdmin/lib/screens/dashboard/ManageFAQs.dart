import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ManageFAQs extends StatefulWidget {
  ManageFAQs({Key key}) : super(key: key);

  @override
  _ManageFAQsState createState() => _ManageFAQsState();
}

class _ManageFAQsState extends State<ManageFAQs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          "Manage FAQ's",
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
    );
  }
}
