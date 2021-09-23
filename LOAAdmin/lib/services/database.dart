import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getChatRoomsList() async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .orderBy("lastMessageTimeStamp", descending: true)
        .where("users", arrayContains: 'admin')
        .snapshots();
  }

  Future<QuerySnapshot> getStudentInfo(String studentEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: studentEmail)
        .get();
  }

  Future addMessage(
      String chatRoomId, String messageId, Map messageInfo) async {
    FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfo);
  }

  updateLastMessageSent(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
