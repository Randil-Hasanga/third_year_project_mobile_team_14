import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

const String USER_COLLECTION = 'users';
const String PROVIDER_DETAILS_COLLECTION = 'provider_details';
const String POSTS_COLLECTION = 'posts';

class FirebaseService {
  FirebaseService();

  Map? currentUser;
  String? uid;

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
        uid = _userCredentials.user!.uid;
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

  // Add job seeker profile



  Future<void> addJobSeekerProfile({
    required String fullName,
    required String email,
    required String address,
    required String nic,
    required String? gender, 
    DateTime? dateOfBirth,
     String? maritalStatus,
      String? nationality,
       String? district,
        String? divisionalsecretariat,
         String? specialNeeds, 
         required TextEditingController contact
  }) async {
    try {
      await _db.collection('jobseekerprofile').add({
        'fullname': fullName,
        'email': email,
        'address':address,
        'gender':gender,
        'nic':nic,
        'dateOfBirth':dateOfBirth,
        'maritalStatus':maritalStatus,
        'nationality':nationality,
        'district':district,
        'divisionalsecretariat':divisionalsecretariat,
        'specialNeeds':specialNeeds,
        'contact':contact
        
      });
    } catch (error) {
      throw Exception('Failed to add job seeker profile');
    }
  }

  Future<void> addJobProviderDetails(
      XFile? logo,
      String membership_number,
      String company_name,
      String company_address,
      String district,
      String industry,
      String org_type,
      String repName,
      String repPost,
      String repTelephone,
      String repMobile,
      String repFax,
      String repEmail) async {
    if (logo != null) {
      try {
        String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
            p.extension(logo.path);

        UploadTask _task =
            _storage.ref('images/$uid/$_fileName').putFile(File(logo.path));

        return _task.then((_snapshot) async {
          String _downloadURL = await _snapshot.ref
              .getDownloadURL(); // get download url for the uploaded imageZz
          await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).set(
            {
              "logo": _downloadURL,
              "membership_number": membership_number,
              "company_name": company_name,
              "company_address": company_address,
              "district": district,
              "industry": industry,
              "org_type": org_type,
              "repName": repName,
              "repPost": repPost,
              "repTelephone": repTelephone,
              "repMobile": repMobile,
              "repFax": repFax,
              "repEmail": repEmail,
            },SetOptions(merge: true)); // set user document for new user
        });
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).set({
          "logo": "",
          "membership_number": membership_number,
          "company_name": company_name,
          "company_address": company_address,
          "district": district,
          "industry": industry,
          "org_type": org_type,
          "repName": repName,
          "repPost": repPost,
          "repTelephone": repTelephone,
          "repMobile": repMobile,
          "repFax": repFax,
          "repEmail": repEmail,
        }, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }
    }
  }
}
