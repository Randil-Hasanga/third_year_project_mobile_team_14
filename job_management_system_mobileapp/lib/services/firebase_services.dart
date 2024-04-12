import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:job_management_system_mobileapp/model/message.dart';

const String USER_COLLECTION = 'users';

class FirebaseService {
  FirebaseService();

  Map? currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_userCredentials != null) {
        currentUser = await _getUserData(uid: _userCredentials.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map?> _getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();

    if (_doc.exists) {
      return _doc.data() as Map;
    } else {
      return null;
    }
  }

  Future<bool> registerUser({
    required String email,
    required String password,
    required String userName,
    required String accountType,
    required bool pending,
  }) async {
    try {
      UserCredential _userCredentials = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (_userCredentials != null) {
        await _db
            .collection(USER_COLLECTION)
            .doc(_userCredentials.user!.uid)
            .set({
          'uid': _userCredentials.user!.uid,
          'username': userName,
          'email': email,
          'type': accountType,
          'profile_pic': '',
          'pending': pending,
          'disabled': false,
        });

        //currentUser = await _getUserData(uid: _userCredentials.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  //get collection of vacancy
  final CollectionReference vacancyCollection =
      FirebaseFirestore.instance.collection('vacancy');

  //create add new vacancy
  Future<void> addVacancy(String companyName, String jobPosition,
      String description, String salary, String location) {
    return vacancyCollection.add({
      'company_name': companyName,
      'job_position': jobPosition,
      'description': description,
      'salary': salary,
      'location': location,
    });
  }

  //delete vacancy
  Future<void> deleteVacancy(String vId) {
    return vacancyCollection.doc(vId).delete();
  }

  void submitProfileData(
      {required String fullName,
      required String address,
      required String gender,
      required String nic,
      required DateTime dateOfBirth,
      required String religion,
      required String maritalStatus,
      required String nationality,
      required bool specialNeed,
      required String district,
      required String email}) {}

  //get stream of job seekers
  Stream<List<Map<String, dynamic>>> getJobSeekerStream() {
    return _db.collection(USER_COLLECTION).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final jobSeeker = doc.data();
        return jobSeeker;
      }).toList();
    });
  }

  //Create a message
  Future<void> sendMessage(String receiverID, message) async {
    //get current Job Provider
    final String currentUserID = _auth.currentUser!.uid.toString();
    final String currentUserEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //send message
    Message newMessage = Message(
      senderID: currentUserEmail!,
      senderEmail: currentUserID,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp.toString(),
    );

    //Construct chat room id for two persons
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // two person chat room id should be same for both users
    String chatRoomID = ids.join('_');

    // messages add to databse
    await _db
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //contruct chat room id for two persons
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _db
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy('timestamp')
        .snapshots();
  }
}
