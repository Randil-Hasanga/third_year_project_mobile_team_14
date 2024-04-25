// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:job_management_system_mobileapp/model/message.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

const String USER_COLLECTION = 'users';
const String PROVIDER_DETAILS_COLLECTION = 'provider_details';
const String POSTS_COLLECTION = 'posts';
const String CV_COLLECTION = 'CVDetails';

class FirebaseService {
  var value;

  FirebaseService();

  Map? currentUser;
  String? uid;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  get instance => null;

  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_userCredentials != null) {
        currentUser = await _getUserData(uid: _userCredentials.user!.uid);
        uid = _auth.currentUser?.uid;
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
    return vacancyCollection.add(
      {
        'company_name': companyName,
        'job_position': jobPosition,
        'description': description,
        'salary': salary,
        'location': location,
      },
    );
  }

  //delete vacancy
  Future<void> deleteVacancy(String vId) {
    return vacancyCollection.doc(vId).delete();
  }

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++get collection of details: Job seeker

  final CollectionReference ProfileJobSeeker =
      FirebaseFirestore.instance.collection('profileJobSeeker');

//add profile details of job seeker

  Future<void> addJobSeekerProfile(
    String fullName,
    String email,
    String address,
    String? gender,
    String nic,
    DateTime? dateOfBirth,
    String? nationality,
    String specialNeeds,
    String? district,
    String divisionalSecretariatController,
    String contact,
  ) {
    return ProfileJobSeeker.add({
      'fullname': fullName,
      'email': email,
      'address': address,
      'gender': gender,
      'nic': nic,
      'dateOfBirth': dateOfBirth,
      'nationality': nationality,
      'specialNeeds': specialNeeds,
      'district': district,
      'divisionalSecretariat': divisionalSecretariatController,
      'contact': contact
    });
  }

  //CV creatoion:

  Future<void> addCVdetails(
      String? title,
      String? gender,
      String? jobType,
      String? workingSection,
      String? maritalStatus,
      String? currentJobStatus,
      String nameWithIni,
      String fullname,
      String nationality,
      String nic,
      String drivingLicence,
      DateTime? selectedDate,
      String? religion,
      String age,
      String email,
      String contactMobile,
      String contactHome,
      String address,
      String? district,
      String divisionalSecretariat,
      String salary, //21 FIELDS

      //EDUCATIONAL TAB
      String? EduQalification,
      String? ProfQualification,
      String OLYear,
      String OLIndex,
      String OLMedium,
      String OLSchool,
      String OLAttempt,
      String? OLStatus,
      String ALYear,
      String ALIndex,
      String ALMedium,
      String ALSchool,
      String ALAttempt,
      String? ALStatus,
      String sec01Name,
      String sec01Ins,
      String sec01duration,
      String sec02Name,
      String sec02Ins,
      String sec02duration,

      //Skill tab
      String yearOfExperience,
      String currentJobPosition,
      String dateOfJoin,
      String currentEmployee,
      String responsibilities,
      String specialSkill,
      String computerSkill,
      String otherSkill,
      String achievements,
      String extraCurricular,
      String trainingReq,
      String prefferedArea,
      String careerGuidance,
      String? sinhalaWriting,
      String? sinhalaReading,
      String? sinhalaSpeaking,
      String? englishSpeaking,
      String? englishReading,
      String? englishWriting,
      String? tamilSpeaking,
      String? tamilReading,
      String? tamilWriting,

      //Job Expectation
      String careerObjective,
      String refeeOne,
      String refeeTwo,
      String preferredJobs,
      String? selectPrefArea) async {
    _db.collection(CV_COLLECTION).doc(uid).set({
      'title': title,
      'gender': gender,
      ' jobType': jobType,
      'workingSection': workingSection,
      'maritalStatus': maritalStatus,
      'currentJobStatus': currentJobStatus,
      'nameWithIni': nameWithIni,
      'fullname': fullname,
      'nationality': nationality,
      'nic': nic,
      'drivingLicence': drivingLicence,
      'selectedDate': selectedDate,
      'religion': religion,
      'age': age,
      'email': email,
      'contactMobile': contactMobile,
      'ContactHome': contactHome,
      'address': address,
      'district': district,
      'divisionalSecretariat': divisionalSecretariat,
      'salary': salary,

      //EDUCATIONAL TAB
      'EduQalification': EduQalification,
      'ProfQualification': ProfQualification,
      'OLYear': OLYear,
      'OLIndex': OLIndex,
      'OLMedium': OLMedium,
      'OLSchool': OLSchool,
      'OLAttempt': OLAttempt,
      'OLStatus': OLStatus,
      'ALYear': ALYear,
      'ALIndex': ALIndex,
      'ALMedium': ALMedium,
      'ALSchool': ALSchool,
      'ALAttempt': ALAttempt,
      'ALStatus': ALStatus,
      'sec01Name': sec01Name,
      'sec01Ins': sec01Ins,
      'sec01duration': sec01duration,
      'sec02Name': sec02Name,
      'sec02Ins': sec02Ins,
      'sec02duration': sec02duration,

      //Skill Tab

      'yearOfExperience': yearOfExperience,
      'currentJobPosition': currentJobPosition,
      'dateOfJoin': dateOfJoin,
      'currentEmployee': currentEmployee,
      'responsibilities': responsibilities,
      'specialSkill': specialSkill,
      'computerSkill': computerSkill,
      'otherSkill': otherSkill,
      'achievements': achievements,
      'extraCurricular': extraCurricular,
      'trainingReq': trainingReq,
      'prefferedArea': prefferedArea,
      'careerGuidance': careerGuidance,
      'sinhalaWriting': sinhalaWriting,
      'sinhalaReading': sinhalaReading,
      'sinhalaWriting': sinhalaWriting,
      'englishSpeaking': englishSpeaking,
      'englishReading': englishReading,
      'englishReading': englishReading,
      'englishWriting': englishWriting,
      'tamilSpeaking': tamilSpeaking,
      'tamilReading,': tamilReading,
      'tamilWriting': tamilWriting,

      //Job Expectation
      'careerObjective': careerObjective,
      'refeeOne': refeeOne,
      'refeeTwo': refeeTwo,
      'preferredJobs': preferredJobs,
      'selectPrefArea': selectPrefArea
    }, SetOptions(merge: true));
  }

  //job provider details

  Future<void> addJobProviderDetails(
    XFile? logo,
    String? logoLink,
    String membershipNumber,
    String companyName,
    String companyAddress,
    String district,
    String industry,
    String orgType,
    String repName,
    String repPost,
    String repTelephone,
    String repMobile,
    String repFax,
    String repEmail,
    String districtFull,
  ) async {
    if (logo != null) {
      try {
        String _fileName = "logo" + p.extension(logo.path);

        UploadTask _task =
            _storage.ref('images/$uid/$_fileName').putFile(File(logo.path));

        return _task.then((_snapshot) async {
          String _downloadURL = await _snapshot.ref
              .getDownloadURL(); // get download url for the uploaded imageZz
          await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).set({
            "logo": _downloadURL,
            "membership_number": membershipNumber,
            "company_name": companyName,
            "company_address": companyAddress,
            "district": district,
            "industry": industry,
            "org_type": orgType,
            "repName": repName,
            "repPost": repPost,
            "repTelephone": repTelephone,
            "repMobile": repMobile,
            "repFax": repFax,
            "repEmail": repEmail,
            "districtFull": districtFull,
          }, SetOptions(merge: true)); // set user document for new user
        });
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).set({
          "logo": logoLink,
          "membership_number": membershipNumber,
          "company_name": companyName,
          "company_address": companyAddress,
          "district": district,
          "industry": industry,
          "org_type": orgType,
          "repName": repName,
          "repPost": repPost,
          "repTelephone": repTelephone,
          "repMobile": repMobile,
          "repFax": repFax,
          "repEmail": repEmail,
          "districtFull": districtFull,
        }, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }
    }
  }

  Future<Map<String, dynamic>?> getCurrentProviderData() async {
    DocumentSnapshot<Map<String, dynamic>?> _doc =
        await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).get();

    if (_doc.exists) {
      return _doc.data();
    } else {
      return null;
    }
  }

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

// get collection of interview detials
  final CollectionReference interviewCollection =
      FirebaseFirestore.instance.collection('interview_details');

  //add scheduled interview
  Future<void> addInterviewDetails(String topic, String description,
      String participant, String type, String date_time) {
    return interviewCollection.add(
      {
        'topic': topic,
        'description': description,
        'participant': participant,
        'type': type,
        'date_time': date_time,
      },
    );
  }
}
