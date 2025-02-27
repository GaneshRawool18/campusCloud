import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:track_tracing/view/faculty/CoursePage.dart';

class FacultyCourseController {
  Future<List<Map<String, dynamic>>> fetchCoursesByDepartment() async {
    List<Map<String, dynamic>> data = [];

    FirebaseFirestore ref = FirebaseFirestore.instance;
    QuerySnapshot queryRef = await ref.collection("Degree").get();
    List<QueryDocumentSnapshot> docs = queryRef.docs;

    for (var doc in docs) {
      String departmentName = doc.id;
      int num = int.parse(doc.get("totalSem"));
      List<Map<String, dynamic>> courses = [];

      for (int i = 1; i <= num; i++) {
        QuerySnapshot querySnap = await ref
            .collection("Degree")
            .doc(doc.id)
            .collection("Semester $i")
            .where("faculty", isEqualTo: facutlyProfileData["facultyName"])
            .get();

        List<QueryDocumentSnapshot> semDoc = querySnap.docs;
        for (var inDoc in semDoc) {
          courses.add({
            ...inDoc.data() as Map<String, dynamic>,
            "courseName": inDoc.id,
            "semester": i,
          });
        }
      }

      if (courses.isNotEmpty) {
        data.add({
          "departmentName": departmentName,
          "courses": courses,
        });
      }
    }

    return data;
  }

  Future<List<Map<String, dynamic>>> fetchDeptWithSem() async {
    List<Map<String, dynamic>> deptList = [];
    try {
      QuerySnapshot collRef =
          await FirebaseFirestore.instance.collection("Degree").get();
      if (collRef.docs.isNotEmpty) {
        for (var doc in collRef.docs) {
          String departmentName = doc.id;
          int totalSem = int.parse(doc['totalSem']);

          List<String> semesterNames = [];
          for (int i = 1; i <= totalSem; i++) {
            semesterNames.add('Semester $i');
          }

          deptList.add({
            'departmentName': departmentName,
            'totalSem': totalSem,
            'semesters': semesterNames,
          });
        }
      } else {
        log("No documents found in the 'Degree' collection.");
      }
    } catch (e) {
      log("Error fetching documents: $e");
    }

    return deptList;
  }

  Future<void> addCourseByFaculty(Map<String, dynamic> data) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("Degree")
        .doc(data["department"])
        .collection(data["semester"])
        .doc(data["courseName"]);
    await docRef.set(data).then((value) async {
      String formatedDateTime = DateFormat.yMMMEd().format(DateTime.now());
      String time = DateFormat('HH:mm a').format(DateTime.now());
      await FirebaseFirestore.instance
          .collection("Notifications")
          .doc(formatedDateTime)
          .collection("StudentNotification")
          .doc(data["department"])
          .set({
        time: {
          "title": "New Course Added",
          "courseCode": data["courseCode"],
          "body": "Course ${data["courseName"]} has been added by the faculty",
          "time": time,
          "isRead": false,
        }
      }, SetOptions(merge: true));
    }).catchError((e) {
      log("Error adding course: $e");
    });
  }

  Future<List<Map<String, dynamic>>> getCourseList() async {
    List<Map<String, dynamic>> courseList = [];

    FirebaseFirestore ref = FirebaseFirestore.instance;

    try {
      QuerySnapshot queryRef = await ref.collection("Degree").get();
      List<QueryDocumentSnapshot> docs = queryRef.docs;

      for (var doc in docs) {
        String departmentName = doc.id;

        int num = int.parse(doc.get("totalSem").toString());

        for (int i = 1; i <= num; i++) {
          QuerySnapshot querySnap = await ref
              .collection("Degree")
              .doc(doc.id)
              .collection("Semester $i")
              .where("faculty", isEqualTo: facutlyProfileData["facultyName"])
              .get();

          List<QueryDocumentSnapshot> semDoc = querySnap.docs;

          for (var inDoc in semDoc) {
            courseList.add({
              ...inDoc.data() as Map<String, dynamic>,
              "courseName": inDoc.id,
              "semester": i.toString(),
              "department": departmentName,
            });
          }
        }
      }
    } catch (e) {
      log("Error fetching course data: $e");
    }

    return courseList;
  }

  Future<bool> updateCourse(Map<String, dynamic> data) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("Degree")
          .doc(data["department"])
          .collection("Semester ${data["semester"]}")
          .doc(data["courseName"]);

      await docRef.set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      log("Error updating course: $e");
    }
    return false;
  }

  Future<bool> deleteCourse(
      String dept, String semester, String courseName) async {
    try {
      QuerySnapshot docRef = await FirebaseFirestore.instance
          .collection("Degree")
          .doc(dept)
          .collection(semester)
          .get();

      for (var doc in docRef.docs) {
        if (doc.id == courseName) {
          await doc.reference.delete().then((value) async {
            String formatedDateTime =
                DateFormat.yMMMEd().format(DateTime.now());
            String time = DateFormat('HH:mm a').format(DateTime.now());
            await FirebaseFirestore.instance
                .collection("Notifications")
                .doc(formatedDateTime)
                .collection("StudentNotification")
                .doc(dept)
                .set({
              time: {
                "title": "Course Deleted",
                "body": "Course $courseName has been deleted by the faculty",
                "time": time,
                "isRead": false,
              }
            }, SetOptions(merge: true));
          });
          return true;
        }
      }
    } catch (e) {
      log("Error deleting course: $e");
    }
    return false;
  }

  Future<Map<String, dynamic>> getCourseDetails(
      String dept, String semester, String courseName) async {
    try {
      DocumentSnapshot docRef = await FirebaseFirestore.instance
          .collection("Degree")
          .doc(dept)
          .collection(semester)
          .doc(courseName)
          .get();

      if (docRef.exists) {
        return {
          ...docRef.data() as Map<String, dynamic>,
        };
      }
    } catch (e) {
      log("Error fetching course details: $e");
    }
    return {};
  }

  Future<void> addCourseSummary(
      String dept, String sem, String course, String summary) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("Degree")
          .doc(dept)
          .collection(sem)
          .doc(course);

      await docRef.set(
        {
          "courseSummary": FieldValue.arrayUnion([summary]),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      log("Error adding course summary: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getStudentReviews(
      String dept, String sem, String course) async {
    List<Map<String, dynamic>> reviews = [];
    try {
      QuerySnapshot queryRef = await FirebaseFirestore.instance
          .collection("Degree")
          .doc(dept)
          .collection(sem)
          .doc(course)
          .collection("Rating")
          .get();

      List<QueryDocumentSnapshot> docs = queryRef.docs;
      for (var doc in docs) {
        DocumentSnapshot str = await FirebaseFirestore.instance
            .collection("Students")
            .doc(doc.id)
            .get();

        reviews.add({
          ...doc.data() as Map<String, dynamic>,
          "name": str.get("name"),
        });
      }
    } catch (e) {
      log("Error fetching student reviews: $e");
    }

    return reviews;
  }
}
