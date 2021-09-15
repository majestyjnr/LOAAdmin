import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:toast/toast.dart';

class AddFaq extends StatefulWidget {
  AddFaq({Key key}) : super(key: key);

  @override
  _AddFaqState createState() => _AddFaqState();
}

class _AddFaqState extends State<AddFaq> {
  TextEditingController _faqQuestion = new TextEditingController();
  TextEditingController _faqAnswer = new TextEditingController();
  bool isLoading = false;
  bool _isquestionValidate = false;
  bool _isanswerValidate = false;
  String dropdownValue = 'Acquistion Section';

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
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Text('Select Video Section:'),
              DropdownButton<String>(
                isExpanded: true,
                value: dropdownValue,
                items: <String>[
                  'Acquisition Section',
                  'Circulation Section',
                  'Information Help Desk Section',
                  'Lending Section',
                  'Quick Reference Section',
                  'Reference Section',
                  'Security Section',
                  'Special Section'
                ].map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                onChanged: (String newLevel) {
                  setState(() {
                    dropdownValue = newLevel;
                  });
                },
              ),
              TextField(
                minLines: 2,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _faqQuestion,
                decoration: InputDecoration(
                    labelText: 'FAQ Question',
                    errorText: _isquestionValidate
                        ? 'Question field must be filled out'
                        : null),
              ),
              SizedBox(
                height: 25,
              ),
              TextField(
                minLines: 6,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _faqAnswer,
                decoration: InputDecoration(
                    labelText: 'FAQ Answer',
                    errorText: _isquestionValidate
                        ? 'Answer field must be filled out'
                        : null),
              ),
              SizedBox(
                height: 40,
              ),
              MaterialButton(
                minWidth: double.infinity,
                height: 45,
                child: isLoading
                    ? NutsActivityIndicator(
                        activeColor: Colors.white,
                      )
                    : Text(
                        'Add FAQ',
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: () {
                  if (_faqQuestion.text.isEmpty) {
                    setState(() {
                      _isquestionValidate = true;
                    });
                  } else if (_faqAnswer.text.isEmpty) {
                    setState(() {
                      _isanswerValidate = true;
                    });
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    Toast.show(
                      'Uploading FAQ',
                      context,
                      duration: Toast.LENGTH_LONG,
                      gravity: Toast.TOP,
                    );
                    try {
                      // Save the user details into the database
                      FirebaseFirestore.instance.collection('FAQs').add({
                        'faqQuestion': _faqQuestion.text,
                        'faqAnswer': _faqAnswer.text,
                        'section': dropdownValue,
                      }).then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        _faqQuestion.text = '';
                        _faqAnswer.text = '';
                        SweetAlert.show(
                          context,
                          title: 'Success!',
                          subtitle: 'FAQ added successfully',
                          style: SweetAlertStyle.success,
                        );
                      }).catchError((value) {
                        setState(() {
                          isLoading = false;
                        });
                        _faqQuestion.text = '';
                        _faqAnswer.text = '';
                        SweetAlert.show(
                          context,
                          title: 'Error!',
                          subtitle: 'Error adding FAQ!',
                          style: SweetAlertStyle.error,
                        );
                      });
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      _faqQuestion.text = '';
                      _faqAnswer.text = '';
                      Toast.show(
                        'Error saving FAQ. Please try again',
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.TOP,
                      );
                    }
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
