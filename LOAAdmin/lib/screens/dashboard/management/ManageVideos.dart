import 'package:LOAAdmin/screens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:sweetalert/sweetalert.dart';

class ManageVideos extends StatefulWidget {
  ManageVideos({Key key}) : super(key: key);

  @override
  _ManageVideosState createState() => _ManageVideosState();
}

class _ManageVideosState extends State<ManageVideos> {
  CollectionReference videosInfo =
      FirebaseFirestore.instance.collection('Videos Info');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.5,
        backgroundColor: Colors.white,
        title: Text(
          'Manage Videos',
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
        stream: videosInfo.snapshots(),
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
                // actions: [
                //   IconSlideAction(
                //     caption: 'Edit',
                //     color: Colors.blue,
                //     icon: Icons.edit,
                //     onTap: () {},
                //   ),
                // ],
                secondaryActions: [
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      DocumentSnapshot data = snapshot.data.docs[index];
                      FirebaseFirestore.instance
                          .collection('Videos Info')
                          .doc(data.id)
                          .delete()
                          .then((value) {
                        SweetAlert.show(
                          context,
                          title: 'Success!',
                          subtitle: 'Video deleted successfully!',
                          style: SweetAlertStyle.success,
                        );
                      }).catchError((error) {
                        SweetAlert.show(
                          context,
                          title: 'Error!',
                          subtitle: 'Error deleting video!',
                          style: SweetAlertStyle.error,
                        );
                      });
                    },
                  ),
                ],
                child: ListTile(
                  leading: Icon(
                    Icons.video_collection_outlined,
                    color: Colors.red,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return WatchVideo(section: '${snapshot.data.docs[index]['videoSection']}');
                        },
                      ),
                    );
                  },
                  title: Text(
                    snapshot.data.docs[index]['videoSection'],
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    snapshot.data.docs[index]['videoDescription'],
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
