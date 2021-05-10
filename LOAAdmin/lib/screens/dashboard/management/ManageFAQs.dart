import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:sweetalert/sweetalert.dart';

class ManageFAQs extends StatefulWidget {
  ManageFAQs({Key key}) : super(key: key);

  @override
  _ManageFAQsState createState() => _ManageFAQsState();
}

class _ManageFAQsState extends State<ManageFAQs> {
  CollectionReference faqs = FirebaseFirestore.instance.collection('FAQs');
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
      body: StreamBuilder(
        stream: faqs.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'An error ocuurred while fetching data',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: NutsActivityIndicator(
                    activeColor: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                actions: [
                  IconSlideAction(
                    caption: 'Edit',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () {},
                  ),
                ],
                secondaryActions: [
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      DocumentSnapshot data = snapshot.data.docs[index];
                      FirebaseFirestore.instance
                          .collection('FAQs')
                          .doc(data.id)
                          .delete()
                          .then((value) {
                        SweetAlert.show(
                          context,
                          title: 'Success!',
                          subtitle: 'FAQ deleted successfully!',
                          style: SweetAlertStyle.success,
                        );
                      }).catchError(() {
                        SweetAlert.show(
                          context,
                          title: 'Error!',
                          subtitle: 'Error deleting FAQ!',
                          style: SweetAlertStyle.error,
                        );
                      });
                    },
                  ),
                ],
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    snapshot.data.docs[index]['faqQuestion'],
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    snapshot.data.docs[index]['faqAnswer'],
                    maxLines: 1,
                  ),
                ),
              );
            },
            separatorBuilder: (context, builder) {
              return Divider(
                height: 0,
              );
            },
          );
        },
      ),
    );
  }
}
