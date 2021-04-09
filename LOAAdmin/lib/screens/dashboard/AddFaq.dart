import 'package:flutter/material.dart';

class AddFaq extends StatefulWidget {
  AddFaq({Key key}) : super(key: key);

  @override
  _AddFaqState createState() => _AddFaqState();
}

class _AddFaqState extends State<AddFaq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          'Add FAQ',
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
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextField(
                minLines: 1,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'FAQ Title',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                minLines: 6,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'FAQ Answer',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              MaterialButton(
                minWidth: double.infinity,
                child: Text(
                  'Add FAQ',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
                elevation: 0.5,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
