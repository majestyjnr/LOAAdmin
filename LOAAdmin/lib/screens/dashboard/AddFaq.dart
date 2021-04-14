import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class AddFaq extends StatefulWidget {
  AddFaq({Key key}) : super(key: key);

  @override
  _AddFaqState createState() => _AddFaqState();
}

class _AddFaqState extends State<AddFaq> {
  var uuid = Uuid();
  TextEditingController _faqQuestion = new TextEditingController();
  TextEditingController _faqAnswer = new TextEditingController();
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
                controller: _faqQuestion,
                decoration: InputDecoration(
                  labelText: 'FAQ Question',
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                minLines: 6,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _faqAnswer,
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
                onPressed: () {
                  try {
                    var id = uuid.v1();
                    // Save the user details into the database
                    FirebaseFirestore.instance.collection('admins').add({
                      'id': id,
                      'faqQuestion': _faqQuestion.text,
                      'faqAnswer': _faqAnswer.text,
                    }).then((value) {
                      Toast.show(
                        'FAQ added successfully.',
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.TOP,
                      );
                    }).catchError((value) {
                      Toast.show(
                        'Error adding FAQ.',
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.TOP,
                      );
                    });
                  } catch (e) {
                    Toast.show(
                      'Error saving FAQ. Please try again',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                    );
                  }
                },
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
