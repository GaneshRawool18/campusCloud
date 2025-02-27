import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_tracing/controller/student/authservice.dart';

class AdminController {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> facultyDataList = [];

  Future<List<Map<String, dynamic>>> fetchStudentCard() async {
    // Fetch the entire Students collection
    QuerySnapshot<Map<String, dynamic>> ref =
        await FirebaseFirestore.instance.collection("Students").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = ref.docs;

    for (var value in docs) {
      Future<DocumentSnapshot<Map<String, dynamic>>> ref =
          FirebaseFirestore.instance.collection("Students").doc(value.id).get();
      DocumentSnapshot<Map<String, dynamic>> doc = await ref;
      data.add({...doc.data()!, "StudentID": value.id});
    }
    // log(data.toString());
    // Optional: Return the data list if needed
    return data;
  }

  Future<List<Map<String, dynamic>>> fetchFacultyData() async {
    QuerySnapshot<Map<String, dynamic>> ref =
        await FirebaseFirestore.instance.collection("Faculty").get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = ref.docs;

    for (var value in docs) {
      String facultyID = value.id;
      Future<DocumentSnapshot<Map<String, dynamic>>> docRef =
          FirebaseFirestore.instance.collection("Faculty").doc(facultyID).get();
      DocumentSnapshot<Map<String, dynamic>> doc = await docRef;

      facultyDataList.add({...doc.data()!, "FacultyID": facultyID});
    }
    log(facultyDataList.toString());
    return facultyDataList;
  }

  Future<void> changeDept(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection("Degree")
          .doc(data["department"])
          .set(data, SetOptions(merge: true));
    } catch (e) {
      log("Error while adding department by admin: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchDept() async {
    List<Map<String, dynamic>> data = [];
    try {
      QuerySnapshot ref =
          await FirebaseFirestore.instance.collection("Degree").get();

      List<QueryDocumentSnapshot> docs = ref.docs;
      for (var doc in docs) {
        data.add(doc.data() as Map<String, dynamic>);
      }
      log("Data fetched: $data");
    } catch (e) {
      log("Error while fetching department by admin: $e");
    }
    return data;
  }

  Future<void> removeDept(String dept) async {
    try {
      await FirebaseFirestore.instance.collection("Degree").doc(dept).delete();
    } catch (e) {
      log("Error while removing department by admin: $e");
    }
  }

  Future<Map<String, dynamic>> fetchAdminDetails() async {
    DocumentSnapshot<Map<String, dynamic>> ref = await FirebaseFirestore
        .instance
        .collection("Admin")
        .doc(Authservice.adminID)
        .get();
    Map<String, dynamic>? data = ref.data();
    return data!;
  }

 Future<Map<String, dynamic>> fetchAllCountsForAnalytics() async {
  Map<String, dynamic> data = {
    "Students": 0,
    "Faculty": 0,
    "Departments": 0,
    "TotalCourses": 0,
  };

  try {
    List<Future> fetchCounts = [
      FirebaseFirestore.instance.collection("Students").get().then((value) {
        data["Students"] = value.docs.length;
      }),
      FirebaseFirestore.instance.collection("Faculty").get().then((value) {
        data["Faculty"] = value.docs.length;
      }),
      FirebaseFirestore.instance.collection("Degree").get().then((value) {
        data["Departments"] = value.docs.length;
      }),
    ];

    await Future.wait(fetchCounts);

    // Fetch all degrees
    QuerySnapshot degreeSnapshot =
        await FirebaseFirestore.instance.collection("Degree").get();

    int totalCourses = 0;

    // Iterate over all degrees to count courses in all semesters
    for (var degreeDoc in degreeSnapshot.docs) {
      String deptName = degreeDoc.id;
      int totalSemesters = int.parse(degreeDoc.get("totalSem").toString());

      // Iterate through semesters
      for (int i = 1; i <= totalSemesters; i++) {
        QuerySnapshot semesterSnapshot = await FirebaseFirestore.instance
            .collection("Degree")
            .doc(deptName)
            .collection("Semester $i")
            .get();

        totalCourses += semesterSnapshot.docs.length;
      }
    }

    data["TotalCourses"] = totalCourses;
    log("Data fetched: $data");
  } catch (error, stacktrace) {
    log("Error fetching analytics data: $error");
    log(stacktrace.toString());
  }

  return data;
}

Future<List<Map<String,dynamic>>> fetchCourseTaskData() async {
  List<Map<String,dynamic>> data = [];
  try {
   QuerySnapshot ref =
          await FirebaseFirestore.instance.collection("Degree").get();
      List<QueryDocumentSnapshot> courseDocs = ref.docs;
      for (var courseDoc in courseDocs) {
        int num = int.parse(courseDoc.get("totalSem").toString());

        // Fetch courses for each semester
        for (int i = 1; i <= num; i++) {
          QuerySnapshot querySnap = await FirebaseFirestore.instance
              .collection("Degree")
              .doc(courseDoc.id)
              .collection("Semester $i")
              .get();

          List<QueryDocumentSnapshot> courseDocument = querySnap.docs;
          for (var doc in courseDocument) {
            data.add({
              "totalTasks": doc.get("totalTasks"),
              "taskCompleted": doc.get("taskCompleted"),
              "courseName": doc.id,
            });
          }
        }
      }
  }
  catch(e){
    log("Error fetching course task data: $e");
  }
  return data;
}
}