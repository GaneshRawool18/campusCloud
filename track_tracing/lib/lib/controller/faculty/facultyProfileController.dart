import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_tracing/controller/student/authservice.dart';

class FacultyProfileController {
  Future<Map<String, dynamic>> fetchFacultyDetails() async {
    Map<String, dynamic> facutlyProfileData = {};
    try {
      DocumentSnapshot facultyDoc = await FirebaseFirestore.instance
          .collection("Faculty")
          .doc(Authservice.staffID)
          .get();
      if (facultyDoc.exists) {
        facutlyProfileData = facultyDoc.data() as Map<String, dynamic>;
      } else {
        log("No faculty found with ID: $Authservice.staffID");
      }
    } catch (e) {
      log("Failed to fetch faculty details: $e");
    }
    return facutlyProfileData;
  }
}
