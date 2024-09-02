// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:job_management_system_mobileapp/Screens/job_vacancy.dart';
import 'package:path/path.dart' as p;

const String USER_COLLECTION = 'users';
const String PROVIDER_DETAILS_COLLECTION = 'provider_details';
const String POSTS_COLLECTION = 'posts';
const String CV_COLLECTION = 'CVDetails';
const String VACANCY_COLLECTION = 'vacancy';
const String SEEKER_PROFILE_DETAILS_COLLECTION = 'profileJobSeeker';
const String NOTIFICATIONS = 'notifications';
const String APPROVAL_COLLECTION = 'provider_approval_data';

class FirebaseService {
  var value;

  FirebaseService();

  Map? currentUser;

  String? uid, email, userType;
  Map? currentSeekerCV;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String getCurrentUserUid() {
    return uid!;
  }

  String getUserType() {
    return userType!;
  }

  String getCurrentUserAuthEmail() {
    return email!;
  }

  //User login
  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential _userCredentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_userCredentials != null) {
        currentUser = await getUserData(uid: _userCredentials.user!.uid);
        uid = _auth.currentUser?.uid;
        this.email = email;
        userType = currentUser!['type'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> getUpdatedUser() async {
    currentUser = await getUserData(uid: uid!);
  }

  Future<Map?> getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();
    currentUser = _doc.data() as Map;
    if (_doc.exists) {
      return _doc.data() as Map;
    } else {
      return null;
    }
  }

  //User register
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
          'isBeingUpdated': false,
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

        //Create new seeker after insert Notification data db
        if (accountType == 'seeker') {
          String notificationId = _db.collection(NOTIFICATIONS).doc().id;
          await _db.collection(NOTIFICATIONS).doc(notificationId).set({
            'notification_id': notificationId,
            'uid': _userCredentials.user!.uid,
            'username': userName,
            'type': accountType,
            'registered_date': currentDate,
            'description': "Register New Job Seeker",
            'notification_go': "officer",
          });
        }

        //Create new provider after insert Notification data db
        if (accountType == 'provider') {
          String notificationId = _db.collection(NOTIFICATIONS).doc().id;
          await _db.collection(NOTIFICATIONS).doc(notificationId).set({
            'notification_id': notificationId,
            'uid': _userCredentials.user!.uid,
            'username': userName,
            'type': accountType,
            'registered_date': currentDate,
            'description': "Register New Job Provider",
            'notification_go': "officer",
          });
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

  //Confirm password
  Future<bool> validateCurrentPassword(String oldPwd) async {
    try {
      final user = _auth.currentUser;
      final credential = EmailAuthProvider.credential(
        email: email!,
        password: oldPwd,
      );
      await user!.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      print("Error in validate password $e");
      return false;
    }
  }

  Future<bool> changePassword(String newPwd) async {
    try {
      final user = _auth.currentUser;
      await user!.updatePassword(newPwd);
      return true;
    } catch (e) {
      print("Error in changing password $e");
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
      String jobType,
      int minimumAge,
      String maxEducation,
      double salary,
      String location,
      DateTime date,
      DateTime expiryDate,
      String orgType,
      String logo,
      String address) async {
    List<String> list = [];
    DocumentReference vacancyRef = await vacancyCollection.add(
      {
        'company_name': companyName,
        'industry': industryType,
        'job_position': jobPosition,
        'description': description,
        'gender': gender,
        'job_type': jobType,
        'minimum_age': minimumAge,
        'max_education': maxEducation,
        'minimum_salary': salary,
        'location': location,
        'uid': uid,
        'created_at': date,
        'expiry_date': expiryDate,
        'org_type': orgType,
        'applied_by': list,
        'active': true,
        'disabled': false,
        'logo': logo,
        'address': address
      },
    );

    // Get the generated ID
    String vacancyId = vacancyRef.id;

    // Update the document with the generated ID
    await vacancyRef.update({'vacancy_id': vacancyId});

    //Create new vacancy after insert Notification data db
    DateTime currentDate = DateTime.now();
    String notificationId = _db.collection(NOTIFICATIONS).doc().id;
    await _db.collection(NOTIFICATIONS).doc(notificationId).set({
      'notification_id': notificationId,
      'uid': uid,
      'company_name': companyName,
      'job_type': jobType,
      'registered_date': currentDate,
      'description': "Publish New Vacancy ",
      'notification_go': "officer",
    });
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

  Future<List<JobVacancy>> getExpiringVacancies() async {
    final now = DateTime.now();
    final threeDaysLater = now.add(Duration(days: 3));

    final QuerySnapshot snapshot = await FirebaseService()
        .vacancyCollection
        .where('expiry_date', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .where('expiry_date',
            isLessThanOrEqualTo: Timestamp.fromDate(threeDaysLater))
        .where('active', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return JobVacancy(
        id: doc.id,
        title: data['title'],
        closingDate: (data['expiry_date'] as Timestamp).toDate(),
        isActive: data['active'],
      );
    }).toList();
  }

  //get vacancy by providers
  Future<List<DocumentSnapshot>> getVacanciesByJobProviders(
      String? providerId) async {
    QuerySnapshot vacanciesSnapshot = await _db
        .collection(VACANCY_COLLECTION)
        .where(uid!, isEqualTo: providerId)
        .get();

    return vacanciesSnapshot.docs;
  }

  //get applicants for all vacanies for relevant provider
  Future<List<String>> getAllApplicantUidsByJobProvider(
      String? providerId) async {
    List<DocumentSnapshot> vacancyDocuments =
        await getVacanciesByJobProviders(providerId);

    Set<String> allApplicantsUids = {};

    for (var vacancy in vacancyDocuments) {
      List<dynamic> appliedBy = vacancy['applied_by'];
      allApplicantsUids.addAll(List<String>.from(appliedBy));
    }
    return allApplicantsUids.toList();
  }

  //get all applicant detials
  Future<List<DocumentSnapshot>> getApplicantsDetails(
      List<String> applicantUids) async {
    List<DocumentSnapshot> applicantDetails = [];

    for (String uid in applicantUids) {
      DocumentSnapshot applicantSnapshot =
          await _db.collection(CV_COLLECTION).doc(uid).get();

      applicantDetails.add(applicantSnapshot);
    }
    return applicantDetails;
  }

  //job seeker details refference
  final CollectionReference seekerDetailsCollection =
      FirebaseFirestore.instance.collection('profileJobSeeker');

  //get job seeker name Stream
  Stream<List<Map<String, dynamic>>> getJobSeekerNameStream(
      String applicantId) {
    return cvDetailsCollection
        .where('uid', isEqualTo: applicantId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final cvDetails = doc.data() as Map<String, dynamic>;

        return cvDetails;
      }).toList();
    });
  }
  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++get collection of details: Job seeker

//add profile details of job seeker

  Future<void> addJobSeekerProfile(
    XFile? profile_picture,
    String? logoLink,
    String fullName,
    String address,
    String? gender,
    String nic,
    DateTime? dateOfBirth,
    String? district,
    String contact,
  ) async {
    if (profile_picture != null) {
      String _imageName = "Profile_Image" + p.extension(profile_picture!.path);

      UploadTask _task = _storage
          .ref('seeker_profile/$uid/$_imageName')
          .putFile(File(profile_picture.path));

      return _task.then((_snapshot) async {
        String _downloadURL = await _snapshot.ref.getDownloadURL();

        return _db.collection(SEEKER_PROFILE_DETAILS_COLLECTION).doc(uid).set({
          'profile_image': _downloadURL,
          'fullname': fullName,
          'email': email,
          'address': address,
          'gender': gender,
          'nic': nic,
          'dateOfBirth': dateOfBirth,
          'district': district,
          'contact': contact
        }, SetOptions(merge: true));
      });
    } else {
      if (logoLink != null) {
        return _db.collection(SEEKER_PROFILE_DETAILS_COLLECTION).doc(uid).set({
          'profile_image': logoLink,
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
    }

    _db.collection(CV_COLLECTION).doc(uid).set({
      'fullname': fullName,
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
    _db.collection(CV_COLLECTION).doc(uid).set({
      'title': title,
      'gender': gender,
      'jobType': jobType,
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
      'tamilReading': tamilReading,
      'tamilWriting': tamilWriting,

      //Job Expectation
      'careerObjective': careerObjective,
      'refeeOne': refeeOne,
      'refeeTwo': refeeTwo,
      'prefered_industries': preferredIndustries,
      'prefferedDistrict': selectPrefferedDistrict,
      'uid': uid,
    }, SetOptions(merge: true));
  }

//get seeker details
  Future<Map<String, dynamic>?> getCurrentSeekerData() async {
    DocumentSnapshot<Map<String, dynamic>?> _doc =
        await _db.collection(SEEKER_PROFILE_DETAILS_COLLECTION).doc(uid).get();

    if (_doc.exists) {
      return _doc.data();
    } else {
      return null;
    }
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
        return null;
      }
    } catch (error) {
      print('Error getting CVDetails for user $uid: $error');
      return null;
    }
  }

//get CV details
  Future<Map<String, dynamic>?> editCVDetails() async {
    DocumentSnapshot<Map<String, dynamic>?> _doc =
        await _db.collection(CV_COLLECTION).doc(uid).get();
    if (_doc.exists) {
      return _doc.data();
    } else {
      return null;
    }
  }

  //job provider details

  Future<void> addJobProviderDetails(
    XFile? logo,
    String? logoLink,
    String membershipNumber,
    String companyName,
    File? businessRegDoc,
    String? businessRegistrationPDFLink,
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
    // if Br link and logo File exist
    if (businessRegistrationPDFLink != null) {
      if (logo != null) {
        try {
          String _imageName = "logo" + p.extension(logo.path);

          UploadTask _task =
              _storage.ref('images/$uid/$_imageName').putFile(File(logo.path));

          return _task.then((_snapshot) async {
            String _downloadURL = await _snapshot.ref.getDownloadURL();
            // get download url for the uploaded imageZz
            await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).set({
              "logo": _downloadURL,
              "membership_number": membershipNumber,
              "company_name": companyName,
              "businessRegDoc": businessRegistrationPDFLink,
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
              "created_date": DateTime.now(),
            }, SetOptions(merge: true));

            await _db.collection(USER_COLLECTION).doc(uid).update({
              'isBeingUpdated': false,
              'pending': true
            }); // set user document for new user
          });
        } catch (e) {
          print(e);
        }
      } else {
        //if BR link exist and LOGO does not exist (Logo Link exist)
        try {
          await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).set({
            "logo": logoLink,
            "membership_number": membershipNumber,
            "company_name": companyName,
            "businessRegDoc": businessRegistrationPDFLink,
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
            "created_date": DateTime.now(),
          }, SetOptions(merge: true));

          await _db
              .collection(USER_COLLECTION)
              .doc(uid)
              .update({'isBeingUpdated': false, 'pending': true});
        } catch (e) {
          print(e);
        }
      }
      //if Br link not exist (BR file exist) and logo file exist (Logo update)
    } else {
      if (logo != null) {
        try {
          String fileName =
              'pdf_BusinessReg${DateTime.now().millisecondsSinceEpoch}.pdf';
          UploadTask _fileTask = _storage
              .ref('BusinessRegistrations/$uid/$fileName')
              .putFile(businessRegDoc!);

          return _fileTask.then((snapshot) async {
            String BrDocURL = await snapshot.ref.getDownloadURL();
            String _imageName = "logo" + p.extension(logo.path);

            UploadTask _task = _storage
                .ref('images/$uid/$_imageName')
                .putFile(File(logo.path));

            return _task.then((_snapshot) async {
              String _downloadURL = await _snapshot.ref.getDownloadURL();
              // get download url for the uploaded imageZz
              await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).set({
                "logo": _downloadURL,
                "membership_number": membershipNumber,
                "company_name": companyName,
                "businessRegDoc": BrDocURL,
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
                "created_date": DateTime.now(),
              }, SetOptions(merge: true));
              await _db.collection(USER_COLLECTION).doc(uid).update({
                'isBeingUpdated': false,
                'pending': true
              }); // set user document for new user
            });
          });
        } catch (e) {
          print(e);
        }
      } else {
        //if Br link not exist (BR file exist) and logo file not exist (Link exist)
        try {
          String fileName =
              'pdf_BusinessReg${DateTime.now().millisecondsSinceEpoch}.pdf';
          UploadTask _fileTask = _storage
              .ref('BusinessRegistrations/$uid/$fileName')
              .putFile(businessRegDoc!);

          return _fileTask.then((_snapshot) async {
            String BrDocURL = await _snapshot.ref.getDownloadURL();
            await _db.collection(PROVIDER_DETAILS_COLLECTION).doc(uid).set({
              "logo": logoLink,
              "membership_number": membershipNumber,
              "company_name": companyName,
              "businessRegDoc": BrDocURL,
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
              "created_date": DateTime.now(),
            }, SetOptions(merge: true));
            await _db
                .collection(USER_COLLECTION)
                .doc(uid)
                .update({'isBeingUpdated': false, 'pending': true});
          });
        } catch (e) {
          print(e);
        }
      }
    }
    //Add new company after insert Notification data db
    DateTime currentDate = DateTime.now();
    String notificationId = _db.collection(NOTIFICATIONS).doc().id;
    await _db.collection(NOTIFICATIONS).doc(notificationId).set({
      "company_name": companyName,
      "membership_number": membershipNumber,
      "org_type": orgType,
      "registered_date": currentDate,
      "description": "Add new company",
      "notification_go": "officer",
    });
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
      return _doc.data();
    } else {
      return null;
    }
  }

  //get Job Seeker Stream
  Stream<List<Map<String, dynamic>>> getJobSeekerStream() {
    return cvDetailsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final cvDetails = doc.data() as Map<String, dynamic>;

        return cvDetails;
      }).toList();
    });
  }

// get collection of interview detials
  final CollectionReference interviewCollection =
      FirebaseFirestore.instance.collection('interview_details');

  //add scheduled interview
  Future<void> addInterviewDetails(
    String companyName,
    String vacancy_id,
    String topic,
    String description,
    String type,
    String link,
    String date_time,
  ) {
    return interviewCollection.add(
      {
        'company_name': companyName,
        'vacancy_id': vacancy_id,
        'topic': topic,
        'description': description,
        'type': type,
        'link': link,
        'date_time': date_time,
        'uid': uid,
      },
    );
  }

  //get Interview detials stream
  Stream<List<Map<String, dynamic>>> getInterviewDetails() {
    return interviewCollection.where('uid', isEqualTo: uid).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final interviewDetails = doc.data() as Map<String, dynamic>;

          return interviewDetails;
        }).toList();
      },
    );
  }

  //get vacancy details for relevant company
  Stream<List<Map<String, dynamic>>> getVacancyDetails() {
    return vacancyCollection.where('uid', isEqualTo: uid).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          final vacancyDetials = doc.data() as Map<String, dynamic>;

          return vacancyDetials;
        }).toList();
      },
    );
  }

  Future<List<Map<String, dynamic>>?> getVacanciesInPrefferedIndustry(
      List<String> preferedIndustries) async {
    int age = int.parse(currentSeekerCV!['age']);

    try {
      QuerySnapshot<Map<String, dynamic>> _querySnapshot = await _db
          .collection(VACANCY_COLLECTION)
          .where('industry', whereIn: preferedIndustries)
          .where('minimum_age', isLessThanOrEqualTo: age)
          .get();

      if (_querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> vacancies =
            _querySnapshot.docs.map((doc) => doc.data()).toList();
        return vacancies;
      } else {
        print("1 No vacancies found.");
        return []; // Return an empty list if there are no vacancies
      }
    } catch (error) {
      print("Error fetching vacancies: $error");
      return null; // Return null to indicate an error
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
      String vacancy_id, String? seeker_id) async {
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

  Future<bool> checkCVExist() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection(CV_COLLECTION)
              .doc(uid)
              .get();
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot2 =
          await FirebaseFirestore.instance
              .collection(USER_COLLECTION)
              .doc(uid)
              .get();

      if (documentSnapshot.exists) {
        bool isDisabled = documentSnapshot2.data()?['disabled'] ?? false;
        return !isDisabled;
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking CV existence: $e");
      return false;
    }
  }

  Future<bool> checkCompanyExist() async {
    try {
      // Check if document exists in PROVIDER_DETAILS_COLLECTION
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection(PROVIDER_DETAILS_COLLECTION)
              .doc(uid)
              .get();

      // If document exists, retrieve user document from USER_COLLECTION
      if (documentSnapshot.exists) {
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection(USER_COLLECTION)
                .doc(uid)
                .get();

        // Check if user is disabled or pending
        bool isDisabled = userSnapshot.data()?['disabled'] ?? false;
        bool isPending = userSnapshot.data()?['pending'] ?? false;

        // Return true if user is not disabled or pending
        return !isDisabled && !isPending;
      } else {
        // Document does not exist in PROVIDER_DETAILS_COLLECTION
        return false;
      }
    } catch (e) {
      print("Error checking company existence: $e");
      return false;
    }
  }

  //get collection of interview progress details
  final CollectionReference interViewProgressCollection =
      FirebaseFirestore.instance.collection('interview_progress');

  //add interview progress

  User? getCurrentUserChat() {
    return _auth.currentUser;
  }

  // logout functiom
  Future<void> logout() async {
    try {
      await _auth.signOut();
      print("Logged out successfully");
    } catch (e) {
      print("Logging out failed : $e");
    }
  }

  Future<String?> getRejectionReason(String docId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection(APPROVAL_COLLECTION).doc(docId).get();
      if (doc.exists) {
        String reason = doc['reason'];
        return reason;
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error in retrieving rejection reason : $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getAppliedJobs() async {
    try {
      QuerySnapshot<Map<String, dynamic>> _querySnapshot = await _db
          .collection(VACANCY_COLLECTION)
          .where('active', isEqualTo: true)
          .where('applied_by', arrayContains: uid)
          .get();

      if (_querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> vacancies =
            _querySnapshot.docs.map((doc) => doc.data()).toList();
        print("applied vacancies: $vacancies");
        return vacancies;
      } else {
        print("1 No vacancies found.");
        return []; // Return an empty list if there are no vacancies
      }
    } catch (e) {
      print("Error retrieving applied jobs : $e");
      return null;
    }
  }
}
