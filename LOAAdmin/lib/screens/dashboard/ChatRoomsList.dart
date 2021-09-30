import 'package:LOAAdmin/screens.dart';
import 'package:LOAAdmin/screens/dashboard/ChatScreen.dart';
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
  Widget chatRooms() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                itemCount: snapshot.data.docs.length,
                // reverse: true,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ChatRoomListTile(ds["lastMessage"], ds.id);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                  );
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
    chatRoomsStream = await DatabaseMethods().getChatRoomsList();
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
            'Incoming Questions',
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
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return Dashboard();
                },
              ));
            },
          ),
        ),
        body: chatRooms());
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId;
  ChatRoomListTile(this.lastMessage, this.chatRoomId);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String studentEmail = "", studentName = "";

  getUserInfo() async {
    studentEmail =
        widget.chatRoomId.replaceAll('admin', "").replaceAll("_", "");

    QuerySnapshot querySnapshot =
        await DatabaseMethods().getStudentInfo(studentEmail);
    studentName = querySnapshot.docs[0]['firstName'] +
        ' ' +
        querySnapshot.docs[0]['lastName'];

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.account_circle,
        color: Colors.blue,
        size: 37,
      ),
      title: Text(studentName),
      subtitle: Text(
        widget.lastMessage,
        maxLines: 1,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatScreen(studentName, studentEmail);
            },
          ),
        );
      },
    );
  }
}
