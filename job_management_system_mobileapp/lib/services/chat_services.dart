import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_management_system_mobileapp/model/message.dart';
import 'package:job_management_system_mobileapp/services/firebase_services.dart';

class ChatService {
  final FirebaseService firebaseService = FirebaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get job seekers stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore
        .collection("users")
        .where('type', isEqualTo: 'seeker')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        //go thorugh each indivual users
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  //get job provider stream
  Stream<List<Map<String, dynamic>>> getProviderStream() {
    return _firestore
        .collection("users")
        .where('type', isEqualTo: 'provider')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        //go thorugh each indivual users
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room ID for the two users
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); //to ensure chatroom id is unique
    String chatRoomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(
          newMessage.toMap(),
        );
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    //construct chat room ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
