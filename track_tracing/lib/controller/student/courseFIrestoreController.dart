import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_tracing/controller/student/authservice.dart';

class CourseController {
  static Map<String, dynamic> subTopicInfo = {};
  static String? selectedCurseName;
  static String? selectedSemister;
  static String? selectedDeptName;

  Future<String> fetchDeptNameForCourseHomePage() async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Students")
        .doc(Authservice.studentID)
        .get();
    return querySnapshot.get("department");
  }

  //Fetch all courses
  Future<List<Map<String, dynamic>>> fetchAllCourses(String deptName) async {
    List<Map<String, dynamic>> data = [];

    try {
      DocumentSnapshot ref = await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .get();

      log(ref.data().toString());
      int num = int.parse(ref.get("totalSem").toString());

      // Fetch courses for each semester
      for (int i = 1; i <= num; i++) {
        QuerySnapshot querySnap = await FirebaseFirestore.instance
            .collection("Degree")
            .doc(deptName)
            .collection("Semester $i")
            .get();

        List<QueryDocumentSnapshot> semDoc = querySnap.docs;
        for (var doc in semDoc) {
          data.add({
            ...doc.data() as Map<String, dynamic>,
            "courseName": doc.id,
            "semester": i.toString(),
          });
        }
      }
    } catch (e) {
      log("Error fetching courses: $e");
    }

    return data;
  }

  //fetch description
  Future<Map<String, dynamic>> fetchCourseDescription(
    String department,
    String semister,
    String courseName,
  ) async {
    Map<String, dynamic> description = {};
    selectedCurseName = courseName;
    selectedSemister = semister;
    selectedDeptName = department;
    DocumentSnapshot reference = await FirebaseFirestore.instance
        .collection("Degree")
        .doc(department)
        .collection(semister)
        .doc(courseName)
        .get();
    if (reference.exists) {
      description.addAll(reference.data() as Map<String, dynamic>);
    } else {
      description.addAll({});
    }
    return description;
  }

  Future<List<String>> fetchDeptName() async {
    List<String> deptName = [];
    QuerySnapshot ref =
        await FirebaseFirestore.instance.collection("Degree").get();
    List<QueryDocumentSnapshot> docs = ref.docs;
    for (var doc in docs) {
      deptName.add(doc.id);
    }
    return deptName;
  }

  // fetch subtopics
  Future<List<String>> fetchSubTopics(
    String department,
    String semister,
    String courseName,
    String topicName,
  ) async {
    List<String>? conveted = [];
    QuerySnapshot reference = await FirebaseFirestore.instance
        .collection("Degree")
        .doc(department)
        .collection(semister)
        .doc(courseName)
        .collection(topicName)
        .get();
    List<QueryDocumentSnapshot> listOfDoc = reference.docs;
    for (var doc in listOfDoc) {
      conveted.add(doc.id);
    }
    return conveted;
  }

  Future<void> fetchSubtopicDescription(
    String department,
    String semister,
    String courseName,
    String topicName,
    String subTopicName,
  ) async {
    subTopicInfo = {};
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection("Degree")
        .doc(department)
        .collection(semister)
        .doc(courseName)
        .collection(topicName)
        .doc(subTopicName)
        .get();
    if (docSnap.exists && docSnap.data() != null) {
      subTopicInfo.addAll({
        ...docSnap.data() as Map<String, dynamic>,
        "subTopicName": subTopicName
      });
    }
  }

  //set course Rating
  Future<bool> reviewCourseThroughRating(
    Map<String, dynamic> data,
  ) async {
    DocumentReference collRef = FirebaseFirestore.instance
        .collection("Degree")
        .doc(selectedDeptName)
        .collection(selectedSemister!)
        .doc(selectedCurseName!)
        .collection("Rating")
        .doc(Authservice.studentID);
    try {
      await collRef.set(data);
      return true;
    } catch (e) {
      log("Error in reviewCourseThroughRating: $e");
      return false;
    }
  }

  //check already rated or not
  Future<Map<String, dynamic>> isAlreadyRated() async {
    DocumentSnapshot collRef = await FirebaseFirestore.instance
        .collection("Degree")
        .doc(selectedDeptName)
        .collection(selectedSemister!)
        .doc(selectedCurseName!)
        .collection("Rating")
        .doc(Authservice.studentID)
        .get();
    return collRef.data() as Map<String, dynamic>;
  }

  //fetch subTopics with marks
  Future<List<Map<String, dynamic>>> fetchSubTopicswithMarks(
    String? topic,
  ) async {
    List<Map<String, dynamic>> data = [];
    log("selectedDeptName $selectedDeptName");
    log("selectedSemister $selectedSemister");
    log("selectedCurseName $selectedCurseName");
    log("topic $topic");

    QuerySnapshot docRef = await FirebaseFirestore.instance
        .collection("Degree")
        .doc(selectedDeptName)
        .collection(selectedSemister!)
        .doc(selectedCurseName)
        .collection(topic!)
        .get();

    for (var docs in docRef.docs) {
      log("docs.id ${docs.id}");
      DocumentSnapshot marksRef = await FirebaseFirestore.instance
          .collection("Degree")
          .doc(selectedDeptName)
          .collection(selectedSemister!)
          .doc(selectedCurseName)
          .collection(topic)
          .doc(docs.id)
          .collection("Submitted")
          .doc(Authservice.studentID) //change
          .get();

      data.add({"subTopic": docs.id, "marks": await marksRef.get("marks")});
    }
    return data;
  }

  void enrollStudentCourse(
      String department, String semester, String courseName) async {
    try {
      DocumentReference ref = FirebaseFirestore.instance
          .collection("Degree")
          .doc(department)
          .collection(semester)
          .doc(courseName);

      await ref.set({
        "enrollStudents": FieldValue.arrayUnion([Authservice.studentID])
      }, SetOptions(merge: true));
    } catch (e) {
      log("Failed to enroll student in course: $e");
    }
  }

  void submitAssignment(
    String topic,
    String subTopic,
    Map<String, dynamic> data,
  ) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("Degree")
          .doc(selectedDeptName)
          .collection(selectedSemister!)
          .doc(selectedCurseName)
          .collection(topic)
          .doc(subTopic)
          .collection("Submitted")
          .doc(Authservice.studentID);

      DocumentReference parentDocRef = FirebaseFirestore.instance
          .collection("Degree")
          .doc(selectedDeptName)
          .collection(selectedSemister!)
          .doc(selectedCurseName);

      await parentDocRef.update({
        "taskCompleted.${Authservice.studentID}": FieldValue.increment(1),
      });

      await docRef.set({
        "answerText": data["answerText"],
        "submittedLink": data["submittedLink"],
        "name": data["name"],
        "marks": data["marks"],
      }, SetOptions(merge: true));
    } catch (e) {
      log("Failed to submit assignment: $e");
    }
  }

  Future<Map<String, dynamic>> checkAlreadySubmittedOrNot(
    String topic,
    String subTopic,
  ) async {
    Map<String, dynamic> linkDetails = {};
    log("in methodd");
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("Degree")
        .doc(selectedDeptName)
        .collection(selectedSemister!)
        .doc(selectedCurseName)
        .collection(topic)
        .doc(subTopic)
        .collection("Submitted")
        .doc(Authservice.studentID);

    try {
      DocumentSnapshot docSnap = await docRef.get();
      if (docSnap.exists) {
        log("document exist");
        linkDetails['name'] = docSnap.get("name") ?? "";
        linkDetails['submittedLink'] = docSnap.get("submittedLink") ?? "";
      }
      log("data of links $linkDetails");
      return linkDetails;
    } catch (e) {
      log("Failed to fetch download link of submitted assignment: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchNotification(String deptName) async {
    Map<String, dynamic> notification = {};
    try {
      QuerySnapshot docSnap =
          await FirebaseFirestore.instance.collection("Notifications").get();
      List<QueryDocumentSnapshot> docs = docSnap.docs;
      for (var doc in docs) {
        DocumentSnapshot docRef = await FirebaseFirestore.instance
            .collection("Notifications")
            .doc(doc.id)
            .collection("StudentNotification")
            .doc(deptName)
            .get();
        if (docRef.exists) {
          notification.addAll(docRef.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      log("Failed to fetch notification: $e");
    }
    return notification;
  }

  Future<void> readNotification(String deptName, String notificationId) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("Notifications")
          .doc(notificationId)
          .collection("StudentNotification")
          .doc(deptName);

      await docRef.update({"isRead": true});
    } catch (e) {
      log("Failed to read notification: $e");
    }
  }
}
