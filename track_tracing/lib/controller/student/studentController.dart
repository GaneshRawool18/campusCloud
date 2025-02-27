import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_tracing/controller/student/authservice.dart';

class Studentcontroller {
  Future<Map<String, dynamic>> fetchStudentdetails(String stuid) async {
    log("Fetching student details...");
    DocumentSnapshot docRef = await FirebaseFirestore.instance
        .collection("Students")
        .doc(stuid)
        .get();
    return docRef.data() as Map<String, dynamic>;
  }

  Future<void> addSkills(Map<String, dynamic> data) async {
    DocumentReference ref = FirebaseFirestore.instance
        .collection("Skills")
        .doc(Authservice.studentID)
        .collection("skill")
        .doc(data["skillName"]);
    ref.set(data);
  }

  Future<List<Map<String, dynamic>>> fetchSkillsData(String stuId) async {
    List<Map<String, dynamic>> data = [];
    QuerySnapshot ref = await FirebaseFirestore.instance
        .collection("Skills")
        .doc(Authservice.studentID)
        .collection("skill")
        .get();
    List<QueryDocumentSnapshot> docs = ref.docs;
    for (var doc in docs) {
      DocumentSnapshot docSnap = await FirebaseFirestore.instance
          .collection("Skills")
          .doc(stuId)
          .collection("skill")
          .doc(doc.id)
          .get();
      data.add(docSnap.data() as Map<String, dynamic>);
    }
    return data;
  }

  Future<List<String>> fetchStudentSkill() async {
    List<String> skills = [];
    QuerySnapshot ref = await FirebaseFirestore.instance
        .collection("Skills")
        .doc(Authservice.studentID)
        .collection("skill")
        .get();
    List docs = ref.docs;
    for (var doc in docs) {
      skills.add(doc.id);
    }
    return skills;
  }

  Future<List<String>> fetchLocations() async {
    List<String> place = [];

    QuerySnapshot ref =
        await FirebaseFirestore.instance.collection("Opportunities ").get();
    List docs = ref.docs;
    for (var doc in docs) {
      place.add(doc.id);
    }
    return place;
  }

  Future<List<Map<String, dynamic>>> searchJobs(
      String place, String skill) async {
    List<Map<String, dynamic>> data = [];
    QuerySnapshot ref = await FirebaseFirestore.instance
        .collection("Opportunities ")
        .doc(place)
        .collection(skill)
        .get();

    for (var doc in ref.docs) {
      data.add(doc.data() as Map<String, dynamic>);
    }

    return data;
  }

  Future<void> updateStudentData(Map<String, dynamic> data) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("Students")
        .doc(Authservice.studentID);
    await docRef.set({
      "name": data["name"],
      "contactNo": data["contactNo"],
      "department": data["department"],
      "dob": data["dob"],
      "emergencyContactName": data["emergencyContactName"],
      "emergencyContactNo": data["emergencyContactNo"],
      "bloodGroup": data["bloodGroup"],
      "profileUrl": data["profileUrl"],
      "signatureUrl": data["signatureUrl"]
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>> fetchCollegeDetail() async {
    DocumentSnapshot docRef = await FirebaseFirestore.instance
        .collection("Colleges")
        .doc("vit")
        .get();

    return docRef.data() as Map<String, dynamic>;
  }

  Future<List<String>> fetchDept() async {
    List<String> dept = [];
    QuerySnapshot ref =
        await FirebaseFirestore.instance.collection("Degree").get();
    List docs = ref.docs;
    for (var doc in docs) {
      dept.add(doc.id);
    }
    return dept;
  }
}
