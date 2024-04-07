import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  //get the job seeker list
  /* Future<List<Map<String, dynamic>>?> getJobSeekersData() async {
  QuerySnapshot<Map<String, dynamic>>? _querySnapshot = await _db
      .collection(USER_COLLECTION)
      .where('type', isEqualTo: 'seeker')
            .get();

  List<Map<String, dynamic>> jobSeekers = [];

  for (QueryDocumentSnapshot<Map<String, dynamic>> doc
      in _querySnapshot.docs) {
    jobSeekers.add(doc.data());
  }

  if (jobSeekers.isNotEmpty) {
    return jobSeekers;
  } else {
    return null;
  }
}*/
}
