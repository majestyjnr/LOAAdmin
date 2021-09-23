import 'package:LOAAdmin/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:random_string/random_string.dart';
import 'package:sweetalert/sweetalert.dart';

class ChatScreen extends StatefulWidget {
  final String studentName, studentEmail;
  ChatScreen(this.studentName, this.studentEmail);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageTextController = TextEditingController();
  String chatRoomId;
  String messageId = "";
  Stream messageStream;
  @override
  void initState() {
    super.initState();
    doThisOnLaunch();
  }

  doThisOnLaunch() async {
    await _getChatDetails();
    getAndSetMessages();
  }

  getChatRoomIdByUsernames(String user, String admin) {
    if (user.substring(0, 1).codeUnitAt(0) >
        admin.substring(0, 1).codeUnitAt(0)) {
      return "$admin\_$user";
    } else {
      return "$user\_$admin";
    }
  }

  _getChatDetails() {
    setState(() {
      chatRoomId = getChatRoomIdByUsernames(widget.studentEmail, 'admin');
    });
  }

  _buildMessage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: messageTextController,
              onChanged: (value) {
                setState(() {
                  _sendMessage(false);
                });
              },
              decoration:
                  InputDecoration.collapsed(hintText: 'Type your question'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Colors.blue,
            onPressed: () {
              _sendMessage(true);
            },
          )
        ],
      ),
    );
  }

  _sendMessage(bool sendClicked) {
    if (messageTextController.text == "") {
      SweetAlert.show(
        context,
        title: 'Error!',
        subtitle: 'Please type a question',
        style: SweetAlertStyle.error,
      );
    } else {
      String message = messageTextController.text;
      var lastMessageTimeStamp = DateTime.now();

      Map<String, dynamic> messageInfo = {
        "message": message,
        "sentBy": 'admin',
        "timestamp": lastMessageTimeStamp
      };
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }
      DatabaseMethods()
          .addMessage(chatRoomId, messageId, messageInfo)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageTimeStamp": lastMessageTimeStamp,
          "lastMessageSentBy": 'admin'
        };
        DatabaseMethods().updateLastMessageSent(chatRoomId, lastMessageInfoMap);

        if (sendClicked) {
          setState(() {
            // remove text from the message input field
            messageTextController.text = "";

            // clear messageID
            messageId = "";
          });
        }
      });
    }
  }

  Widget chatTile(String message, bool sentByMe) {
    return Row(
      mainAxisAlignment:
          sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                bottomRight:
                    sentByMe ? Radius.circular(0) : Radius.circular(24),
                topRight: Radius.circular(24),
                bottomLeft: sentByMe ? Radius.circular(24) : Radius.circular(0),
              ),
              color: Colors.blue,
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 40, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];

                  return chatTile(ds['message'], "admin" == ds['sentBy']);
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

  getAndSetMessages() async {
    print('My chatRoomId is . $chatRoomId');

    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
    print('My name is Solomon. $messageStream');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: ListTile(
          leading: Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 37,
          ),
          title: Text(
            widget.studentName,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: chatMessages(),
                ),
              ),
            ),
            _buildMessage(),
          ],
        ),
      ),
    );
  }
}
