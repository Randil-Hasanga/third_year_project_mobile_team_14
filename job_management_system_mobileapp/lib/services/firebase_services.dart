// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
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
const String VACANCY_COLLECTION = 'vacancy';
const String SEEKER_PROFILE_DETAILS_COLLECTION = 'profileJobSeeker';

class FirebaseService {
  var value;

  FirebaseService();

  Map? currentUser;

  String? uid;
  Map? currentSeekerCV;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? getCurrentUserChat() {
    return _auth.currentUser;
  }

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
      DateTime currentDate = DateTime.now();
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
          'registered_date': currentDate,
        });

        if (accountType == 'seeker') {
          await _db
              .collection(SEEKER_PROFILE_DETAILS_COLLECTION)
              .doc(_userCredentials.user!.uid)
              .set(
            {
              'registered_date': currentDate,
            },
            SetOptions(merge: true),
          );
        }
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
  Future<void> addVacancy(
      String companyName,
      String industryType,
      String jobPosition,
      String description,
      String gender,
      int minimumAge,
      String maxEducation,
      double salary,
      String location,
      DateTime date,
      String orgType) async {
    DocumentReference vacancyRef = await vacancyCollection.add(
      {
        'company_name': companyName,
        'industry': industryType,
        'job_position': jobPosition,
        'description': description,
        'gender': gender,
        'minimum_age': minimumAge,
        'max_education': maxEducation,
        'minimum_salary': salary,
        'location': location,
        'uid': uid,
        'created_at': date,
        'org_type': orgType,
      },
    );

    // Get the generated ID
    String vacancyId = vacancyRef.id;

    // Update the document with the generated ID
    await vacancyRef.update({'vacancy_id': vacancyId});
  }

  //delete vacancy
  Future<void> deleteVacancy(String vId) {
    return vacancyCollection.doc(vId).delete();
  }

  //Udpate vacancy
  Future<void> updateVacancy(
    String vId,
    String jobPosition,
    String description,
    String gender,
    double minimumAge,
    String maxEducation,
    double salary,
    String location,
    DateTime date,
  ) {
    return vacancyCollection.doc(vId).update(
      {
        'job_position': jobPosition,
        'description': description,
        'gender': gender,
        'minimum_age': minimumAge,
        'max_education': maxEducation,
        'minimum_salary': salary,
        'location': location,
        'date': date,
      },
    );
  }

  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++get collection of details: Job seeker

//add profile details of job seeker

  Future<void> addJobSeekerProfile(
    String fullName,
    String email,
    String address,
    String? gender,
    String nic,
    DateTime? dateOfBirth,
    String? district,
    String contact,
  ) {
    return _db.collection(SEEKER_PROFILE_DETAILS_COLLECTION).doc(uid).set({
      'fullname': fullName,
      'email': email,
      'address': address,
      'gender': gender,
      'nic': nic,
      'dateOfBirth': dateOfBirth,
      'district': district,
      'contact': contact
    }, SetOptions(merge: true));
  }

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++CV creatoion:

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
      //String prefferedArea,
      String careerGuidance,
      String? sinhalaSpeaking,
      String? sinhalaReading,
      String? sinhalaWriting,
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
      List<String> preferredIndustries,
      String? selectPrefferedDistrict) async {
    final preferredIndustriesString = jsonEncode(preferredIndustries);
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
      'cv_email': email,
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
      //'prefferedArea': prefferedArea,
      'careerGuidance': careerGuidance,
      'sinhalaSpeaking': sinhalaSpeaking,
      'sinhalaReading': sinhalaReading,
      'sinhalaWriting': sinhalaWriting,
      'englishSpeaking': englishSpeaking,
      'englishReading': englishReading,
      'englishWriting': englishWriting,
      'tamilSpeaking': tamilSpeaking,
      'tamilReading,': tamilReading,
      'tamilWriting': tamilWriting,

      //Job Expectation
      'careerObjective': careerObjective,
      'refeeOne': refeeOne,
      'refeeTwo': refeeTwo,
      'prefered_industries': preferredIndustriesString,
      'prefferedDistrict': selectPrefferedDistrict,
      'uid': uid,
    }, SetOptions(merge: true));
  }

// CV PDF genarating

  final CollectionReference cvDetailsCollection =
      FirebaseFirestore.instance.collection('CVDetails');

  // Method to get details of a CV from Firestore
  Future<DocumentSnapshot?> getCVDetails(String uid) async {
    try {
      // Query the "CVDetails" collection to retrieve the document with the given user ID
      DocumentSnapshot querySnapshot = await cvDetailsCollection.doc(uid).get();

      // Check if the document exists
      if (querySnapshot.exists) {
        return querySnapshot;
      } else {
        print('No CVDetails document found for user $uid');
        return null;
      }
    } catch (error) {
      print('Error getting CVDetails for user $uid: $error');
      return null;
    }
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

  //current provider data
  Future<Map<String, dynamic>?> getCurrentProviderData() async {
    DocumentSnapshot<Map<String, dynamic>?> _doc =
        await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).get();

    if (_doc.exists) {
      return _doc.data();
    } else {
      return null;
    }
  }

  //get current seeker CV

  Future<Map<String, dynamic>?> getCurrentSeekerCV() async {
    DocumentSnapshot<Map<String, dynamic>?> _doc =
        await _db.collection(CV_COLLECTION).doc(uid).get();

    if (_doc.exists) {
      currentSeekerCV = _doc.data() as Map;
      print("Current CV : $currentSeekerCV");
      return _doc.data();
    } else {
      return null;
    }
  }

// get collection of interview detials
  final CollectionReference interviewCollection =
      FirebaseFirestore.instance.collection('interview_details');

  //add scheduled interview
  Future<void> addInterviewDetails(
    String topic,
    String description,
    String vacancy_id,
    String type,
    String link,
    String date_time,
  ) {
    return interviewCollection.add(
      {
        'topic': topic,
        'description': description,
        'vacancy_id': vacancy_id,
        'type': type,
        'link': link,
        'date_time': date_time,
        'uid': uid,
      },
    );
  }

  Future<List<Map<String, dynamic>>?> getVacanciesInPrefferedIndustry(
      List<String> preferedIndustries) async {
    int age = int.parse(currentSeekerCV!['age']);
    print(preferedIndustries);

    try {
      QuerySnapshot<Map<String, dynamic>> _querySnapshot = await _db
          .collection(VACANCY_COLLECTION)
          .where('industry', whereIn: preferedIndustries)
          .where('minimum_age', isLessThanOrEqualTo: age)
          .get();

      if (_querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> vacancies =
            _querySnapshot.docs.map((doc) => doc.data()).toList();
        print("Male:Industry:age: $vacancies");
        return vacancies;
      } else {
        print("1 No vacancies found.");
        return []; // Return an empty list if there are no vacancies
      }
    } catch (error) {
      print("Error fetching vacancies: $error");
      return null; // Return null to indicate an error occurred
    }
  }

  Future<void> applyForVacancy(String vacancy_id, String seeker_id) async {
    DateTime currentDate = DateTime.now();
    try {
      await _db.collection(VACANCY_COLLECTION).doc(vacancy_id).update({
        'applied_by': FieldValue.arrayUnion(
          [seeker_id],
        ),
        'applied_at': currentDate,
      });
    } catch (e) {
      print("Error applying for vacancies: $e");
    }
  }

  Future<void> removeSeekerFromVacancy(
      String vacancy_id, String seeker_id) async {
    try {
      await _db.collection(VACANCY_COLLECTION).doc(vacancy_id).update({
        'applied_by': FieldValue.arrayRemove(
          [seeker_id],
        ),
        'applied_at': FieldValue.delete(),
      });
    } catch (e) {
      print("Error removing seeker from vacancies: $e");
    }
  }
}
