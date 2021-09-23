import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseModels {
  Future<Stream<QuerySnapshot>> getChatRoomsList() async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .orderBy("lastMessageTimeStamp", descending: true)
        .snapshots();
  }

  getStudentInfo(String studentEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where('email', isEqualTo: studentEmail)
        .get();
  }
}
