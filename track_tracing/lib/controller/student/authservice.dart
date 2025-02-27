import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_tracing/controller/admin/firebaseAdminController.dart';
import 'package:track_tracing/controller/student/courseFIrestoreController.dart';
import 'package:track_tracing/controller/student/sharedPreference.dart';

class Authservice {
  //Instance of authentication
  final _auth = FirebaseAuth.instance;
  static String? studentID; //Control who is logged in now
  static String? staffID;
  static String? adminID;

  void setStudentId(String str) {
    studentID = "";
    String id = str;
    List<String> splited = id.split("@");
    RegExp regExp = RegExp(r'\d+');
    studentID = regExp.firstMatch(splited[0])?.group(0) ?? "0";
    SharedPreferenceController.setData(isLogin: true, studentID: studentID!);
    log("Student ID set successfully: $studentID");
  }

  void setFacultyId(String email) {
    staffID = "";
    List<String> splitEmail = email.split("@");
    RegExp regExp = RegExp(r'\d+');
    staffID = regExp.firstMatch(splitEmail[0])?.group(0);
    SharedPreferenceController.setData(isLogin: true, studentID: staffID!);
    log("Faculty ID set successfully: $staffID");
  }

  void setAdminID(String email) {
   
    adminID ="";
    List<String> splitEmail = email.split("@");
    RegExp regExp = RegExp(r'\d+');
    adminID = regExp.firstMatch(splitEmail[0])?.group(0) ?? "";
    SharedPreferenceController.setData(isLogin: true, studentID: adminID!);
    log("Faculty ID set successfully: $adminID");
  }

/*This method is used to signin in our app using firebase 
  @param email and password
  @return user
  @auth Abhishek Bhosale
  */
  Future<bool> signingWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        setStudentId(userCredential.user!.email!);
        return true;
      }
      return false;
    } catch (e) {
      log("Error $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> creaAcountWithEmailAndPassword(
      String? email, String pass) async {
    _auth.createUserWithEmailAndPassword(email: email!, password: pass);
  }
}
