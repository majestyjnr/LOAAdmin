import 'package:LOAAdmin/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';

class ChatRoomsList extends StatefulWidget {
  ChatRoomsList({Key key}) : super(key: key);

  @override
  _ChatRoomsListState createState() => _ChatRoomsListState();
}

class _ChatRoomsListState extends State<ChatRoomsList> {
  Stream chatRoomsStream;
  String admin = 'admin';

  Widget chatRoomListTile() {
    return Row(
      children: [
        Icon(
          Icons.account_circle,
          color: Colors.black,
          size: 37,
        ),
        SizedBox(width: 25)

      ],
    );
  }

  Widget chatRooms() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 40, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Text(ds.id.replaceAll(admin, "").replaceAll("_", ""));
                },
              )
            : Center(
                child: NutsActivityIndicator(
                  activeColor: Colors.blue,
                  radius: 30,
                ),
              );
      },
    );
  }

  getChatRooms() async {
    chatRoomsStream = await DatabaseModels().getChatRoomsList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Chats',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
