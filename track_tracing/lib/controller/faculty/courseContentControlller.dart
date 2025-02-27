import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CourseContentController {
  Future<bool> addNewAssignment(String? deptName, String? semName,
      String? courseName, Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .collection(semName!)
          .doc(courseName)
          .collection(data["topicName"])
          .doc(data["assignmentName"])
          .set(data)
          .then((value) async {
        String formatedDateTime = DateFormat.yMMMEd().format(DateTime.now());
        String time = DateFormat('HH:mm a').format(DateTime.now());
        await FirebaseFirestore.instance
            .collection("Notifications")
            .doc(formatedDateTime)
            .collection("StudentNotification")
            .doc(deptName)
            .set({
          time: {
            "message": "New Assignment added in $courseName",
            "title": "New Assignment",
            "assignment": data["assignmentName"],
            "time": time,
            "isRead": false,
          }
        }, SetOptions(merge: true));
      });

      await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .collection(semName)
          .doc(courseName)
          .update({"totalTasks": FieldValue.increment(1)});

      await FirebaseFirestore.instance.collection("Topics").doc(deptName).set(
        {
          semName: {
            courseName: FieldValue.arrayUnion(
              data["topicName"] is List
                  ? data["topicName"]
                  : [data["topicName"]],
            ),
          },
        },
        SetOptions(merge: true),
      );

      return true;
    } catch (e) {
      log("Error in addNewAssignment: $e");
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> fetchAllAssignments(
    String? deptName,
    String? semName,
    String? courseName,
  ) async {
    List<dynamic> topics = [];
    List<Map<String, dynamic>> assignments = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("Topics")
          .doc(deptName)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? semData = snapshot.data()?["$semName"];
        if (semData != null && semData["$courseName"] != null) {
          topics = semData["$courseName"];
        }
      }
      for (var topic in topics) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("Degree")
            .doc(deptName)
            .collection(semName!)
            .doc(courseName)
            .collection(topic)
            .get();

        List<QueryDocumentSnapshot> docs = querySnapshot.docs;
        for (var doc in docs) {
          assignments.add({
            ...doc.data() as Map<String, dynamic>,
            "topicName": topic,
            "assignmentName": doc.id
          });
        }
      }
      return assignments;
    } catch (e) {
      log("Error in fetchAllAssignments: $e");
    }
    return [];
  }

  Future<bool> updateDescription(
      String? deptName,
      String? semName,
      String? courseName,
      String? topicName,
      String? assignmentName,
      String? description) async {
    try {
      await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .collection(semName!)
          .doc(courseName)
          .collection(topicName!)
          .doc(assignmentName)
          .update({"description": description});
      return true;
    } catch (e) {
      log("Error in updateDescription: $e");
    }
    return false;
  }

  Future<bool> updateDueDate(
      String? deptName,
      String? semName,
      String? courseName,
      String? topicName,
      String? assignmentName,
      String? dueDate) async {
    try {
      log("Due Date: $dueDate");
      await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .collection(semName!)
          .doc(courseName)
          .collection(topicName!)
          .doc(assignmentName)
          .update({"deadline": dueDate});
      return true;
    } catch (e) {
      log("Error in updateDueDate: $e");
    }
    return false;
  }

  Future<bool> updateAttachmentAndName(
      String? deptName,
      String? semName,
      String? courseName,
      String? topicName,
      String? assignmentName,
      String? attachment,
      String? assignmentNameNew) async {
    try {
      log("Attachment: $attachment");
      await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .collection(semName!)
          .doc(courseName)
          .collection(topicName!)
          .doc(assignmentName)
          .update({
        "attachedFileUrl": attachment,
        "attachedFileName": assignmentNameNew
      });
      return true;
    } catch (e) {
      log("Error in updateAttachmentAndName: $e");
    }
    return false;
  }

  Future<List<dynamic>> fetchTopicsList(
    String? deptName,
    String? semName,
    String? courseName,
  ) async {
    List<dynamic> topics = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("Topics")
          .doc(deptName)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? semData = snapshot.data()?["$semName"];
        if (semData != null && semData["$courseName"] != null) {
          topics = semData["$courseName"];
        }
      }
      log("Topics: $topics");
      return topics;
    } catch (e) {
      log("Error in fetchTopicsList: $e");
    }
    return [];
  }

  Future<bool> deleteAssignment(
    String? deptName,
    String? semName,
    String? courseName,
    String? topicName,
    String? assignmentName,
  ) async {
    try {
      // Ensure the parameters are not null
      if (deptName == null ||
          semName == null ||
          courseName == null ||
          topicName == null ||
          assignmentName == null) {
        log("Error: One or more parameters are null.");
        return false;
      }

      // Fetch the students who submitted the assignment
      QuerySnapshot docsList = await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .collection(semName)
          .doc(courseName)
          .collection(topicName)
          .doc(assignmentName)
          .collection("Submitted")
          .get();

      // Iterate over the submissions and update the "taskCompleted" field
      for (var doc in docsList.docs) {
        // log(message: "Doc: ${doc.id}");
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection("Degree")
            .doc(deptName)
            .collection(semName)
            .doc(courseName)
            .get();

        // Safely update taskCompleted field, if it's a map, decrement it
        Map<String, dynamic>? taskCompleted =
            (docSnapshot.data() as Map<String, dynamic>?)?['taskCompleted'];
        if (taskCompleted != null && taskCompleted.containsKey(doc.id)) {
          // Decrement the value for the student ID
          taskCompleted[doc.id] = (taskCompleted[doc.id] ?? 0) - 1;

          // Update the Firestore document
          await docSnapshot.reference.update({'taskCompleted': taskCompleted});
          log("Decremented taskCompleted for ${doc.id}");
        } else {
          log("Student ${doc.id} not found in taskCompleted map");
        }
      }

      // Delete the assignment document
      await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .collection(semName)
          .doc(courseName)
          .collection(topicName)
          .doc(assignmentName)
          .delete();

      // Update the course to reflect one less task
      await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .collection(semName)
          .doc(courseName)
          .update({"totalTasks": FieldValue.increment(-1)});

      // Send a notification for the deleted assignment
      String formattedDateTime = DateFormat.yMMMEd().format(DateTime.now());
      String time = DateFormat('HH:mm a').format(DateTime.now());
      await FirebaseFirestore.instance
          .collection("Notifications")
          .doc(formattedDateTime)
          .collection("StudentNotification")
          .doc(deptName)
          .set({
        time: {
          "body": "Assignment $assignmentName has been deleted",
          "title": "Assignment Deleted",
          "time": time,
          "isRead": false,
        }
      }, SetOptions(merge: true));

      // Check if the topic is empty and remove it from topics if necessary
      bool isEmpty =
          await _isCollectionEmpty(deptName, semName, courseName, topicName);
      log("isEmpty: $isEmpty");
      if (isEmpty) {
        await _removeTopicFromTopics(deptName, semName, courseName, topicName);
      }

      return true;
    } catch (e) {
      log("Error in deleteAssignment: $e");
    }
    return false;
  }

  Future<bool> _isCollectionEmpty(String? deptName, String? semName,
      String? courseName, String? topicName) async {
    var snapshot = await FirebaseFirestore.instance
        .collection("Degree")
        .doc(deptName)
        .collection(semName!)
        .doc(courseName)
        .collection(topicName!)
        .get();

    return snapshot.docs.isEmpty;
  }

  Future<void> _removeTopicFromTopics(String? deptName, String? semName,
      String? courseName, String? topicName) async {
    // Ensure all keys are non-null
    if (deptName == null ||
        semName == null ||
        courseName == null ||
        topicName == null) {
      log("Error: One or more parameters are null.");
      return;
    }

    try {
      var topicsDocRef =
          FirebaseFirestore.instance.collection("Topics").doc(deptName);

      var topicsDoc = await topicsDocRef.get();

      if (topicsDoc.exists) {
        // Safely extract the nested list of topics
        var currentTopics =
            (topicsDoc.data()?[semName]?[courseName] as List<dynamic>?) ?? [];

        if (currentTopics.contains(topicName)) {
          // Remove the topic locally
          currentTopics.remove(topicName);

          // Update Firestore document
          await topicsDocRef.set(
            {
              semName: {
                courseName:
                    currentTopics, // Replace the array with the updated one
              },
            },
            SetOptions(merge: true),
          );

          log("Removed topic $topicName from Topics collection.");
        } else {
          log("Topic $topicName not found in Topics collection.");
        }
      } else {
        log("Document does not exist for department $deptName.");
      }
    } catch (e) {
      log("Error removing topic from Topics collection: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchStudentEvaluations(
      String? deptName,
      String? semName,
      String? courseName,
      String? topicName,
      String? assignmentName) async {
    List<Map<String, dynamic>> evaluations = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("Degree")
              .doc(deptName)
              .collection(semName!)
              .doc(courseName)
              .collection(topicName!)
              .doc(assignmentName)
              .collection("Submitted")
              .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          querySnapshot.docs;
      for (var doc in docs) {
        DocumentSnapshot docSnap = await FirebaseFirestore.instance
            .collection("Students")
            .doc(doc.id)
            .get();

        evaluations.add({
          ...doc.data(),
          "studentId": doc.id,
          "studentName": docSnap.get("name")
        });
      }
      return evaluations;
    } catch (e) {
      log("Error in fetchStudentEvaluations: $e");
    }
    return [];
  }

  Future<void> updateMarks(
      String? deptName,
      String? semName,
      String? courseName,
      String? topicName,
      String? assignmentName,
      String? studentId,
      String? marks) async {
    try {
      await FirebaseFirestore.instance
          .collection("Degree")
          .doc(deptName)
          .collection(semName!)
          .doc(courseName)
          .collection(topicName!)
          .doc(assignmentName)
          .collection("Submitted")
          .doc(studentId)
          .update({"marks": marks});
    } catch (e) {
      log("Error in updateMarks: $e");
    }
  }

  Future<List<String>> fetchAssignemtsNameList(String? deptName,
      String? semName, String? courseName, String topicName) async {
    List<String> assignments = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("Degree")
              .doc(deptName)
              .collection(semName!)
              .doc(courseName)
              .collection(topicName)
              .get();

      List docs = querySnapshot.docs;

      for (var doc in docs) {
        assignments.add(doc.id);
      }
      return assignments;
    } catch (e) {
      log("Error in fetchAssignemtsNameList: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchStudentsList(String? dept,
      String? sem, String? course, String? topic, String? assignment) async {
    List<Map<String, dynamic>> students = [];
    try {
      QuerySnapshot qSnapshot = await FirebaseFirestore.instance
          .collection("Degree")
          .doc(dept)
          .collection(sem!)
          .doc(course)
          .collection(topic!)
          .doc(assignment)
          .collection("Submitted")
          .get();

      List<QueryDocumentSnapshot> docs = qSnapshot.docs;
      for (var doc in docs) {
        DocumentSnapshot<Map<String, dynamic>> studentDoc =
            await FirebaseFirestore.instance
                .collection("Students")
                .doc(doc.id)
                .get();
        students.add({
          "studentId": doc.id,
          "studentName": studentDoc.get("name"),
          "status": "Completed",
        });
      }
      return students;
    } catch (e) {
      log("Error in fetchStudentList: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchTotalEnrolledStudents(
      String? dept, String? sem, String? course) async {
    try {
      List students = [];
      DocumentSnapshot docRef = await FirebaseFirestore.instance
          .collection("Degree")
          .doc(dept)
          .collection(sem!)
          .doc(course)
          .get();

      if (docRef.exists) {
        students = docRef.get("enrollStudents");
        List<Map<String, dynamic>> studentList = [];
        for (var student in students) {
          DocumentSnapshot<Map<String, dynamic>> studentDoc =
              await FirebaseFirestore.instance
                  .collection("Students")
                  .doc(student)
                  .get();
          studentList.add({
            "studentId": student,
            "studentName": studentDoc.get("name"),
          });
        }
        log("Student List: $studentList");
        return studentList;
      }
    } catch (e) {
      log("Error in fetchTotalEnrolledStudents: $e");
    }
    return [];
  }
}
