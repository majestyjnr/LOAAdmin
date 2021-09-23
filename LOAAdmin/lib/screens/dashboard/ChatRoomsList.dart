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

  // Widget chatRoomListTile(String name, String lastMessage) {
  //   return Row(
  //     children: [
  //       Icon(
  //         Icons.account_circle,
  //         color: Colors.black,
  //         size: 37,
  //       ),
  //       SizedBox(width: 25),
  //       Column(
  //         children: [
  //           Text(""),
  //           Text(lastMessage)
  //         ],
  //       )
  //     ],
  //   );
  // }

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
                  return ChatRoomListTile(ds["lastMessage"], ds.id);
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

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId;
  ChatRoomListTile(this.lastMessage, this.chatRoomId);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String studentEmail, studentName;

  getUserInfo() async {
    studentEmail =
        widget.chatRoomId.replaceAll('admin', "").replaceAll("_", "");

    QuerySnapshot querySnapshot =
        await DatabaseModels().getStudentInfo(studentEmail);
    studentName = querySnapshot.docs[0]['firstName'] +
        ' ' +
        querySnapshot.docs[0]['lastName'];

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.account_circle,
          color: Colors.black,
          size: 37,
        ),
        SizedBox(width: 25),
        Column(
          children: [Text(studentName), Text(widget.lastMessage)],
        )
      ],
    );
  }
}
