
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_tracing/controller/student/authservice.dart';

class FirebaseAdminController {
  static int? studentID;

  Future<String> getStudentID() async {
    QuerySnapshot ref =
        await FirebaseFirestore.instance.collection("Students").get();
    List<QueryDocumentSnapshot> docs = ref.docs;
    int num = int.parse(docs.last.id);
    studentID = num + 1;
    return studentID.toString();
  }

  /* 
  Sends a registration request to the admin by adding a document in the Firestore database.
  
  @param date - The date on which the notification is sent, used as the document ID for organizational purposes.
  @param time - The specific time at which the notification should appear, used as a document ID within the `who` collection.
  @param who - A string indicating the collection within `Notifications` to which the request is sent, typically representing the admin or group.
  @param studentData - A map containing the student's data, such as name, department, contact details, etc.
  
  @return A boolean value indicating whether the notification was successfully sent (`true`) or if an error occurred (`false`).
  */
  Future<bool> sendRequestToAdminForRegistration(String date, String time,
      String who, Map<String, dynamic> studentData) async {
    DocumentReference reference = FirebaseFirestore.instance
        .collection("Notifications")
        .doc(date)
        .collection(who)
        .doc(time);

    try {
      await reference.parent.parent!
          .set({"isRead": "false"}, SetOptions(merge: true));
      await reference.set(
          {...studentData, "isDone": "false", "title": "Registration request"});
      return true;
    } catch (e) {
      log("Failed to send request: $e");
      return false;
    }
  }

  /* 
  Fetches all admin notifications from the Firestore database and organizes them into a list.
  
  This method retrieves all notifications from the "Notifications" collection, iterates over each date-based document, and fetches the
  "AdminNotifications" sub-collection within each document. Each document's data, including name, department, contact information, 
  and profile URL, is stored in a list of maps.
  @return A list of maps where each map represents a notification's details (name, department, contact, isDone status, and profile URL).
          If an error occurs, an empty list is returned and the error is printed to the console.
  */
  Future<List<Map<String, dynamic>>> fetchAdminNotifications() async {
    List<Map<String, dynamic>> notificationList = [];

    try {
      QuerySnapshot notificationSnapshot =
          await FirebaseFirestore.instance.collection("Notifications").get();
      List<QueryDocumentSnapshot> dateDocs = notificationSnapshot.docs;

      // Loop through each document in the main collection
      for (QueryDocumentSnapshot dateDoc in dateDocs) {
        Map<String, dynamic> notificationData = {
          "name": dateDoc.id,
          "date": dateDoc.id,
          "times": []
        };

        QuerySnapshot adminNotificationSnapshot =
            await dateDoc.reference.collection("AdminNotifications").get();
        List<QueryDocumentSnapshot> timeDocs = adminNotificationSnapshot.docs;

        for (QueryDocumentSnapshot timeDoc in timeDocs) {
          Map<String, dynamic> timeData =
              timeDoc.data() as Map<String, dynamic>;

          notificationData["times"].add({
            "time": timeDoc.id,
            "name": timeData["name"],
            "department": timeData["department"],
            "contact": timeData["contactNo"],
            "isDone": timeData["isDone"],
            "profileURL": timeData["profileUrl"],
            "title": timeData["title"]
          });
        }

        notificationList.add(notificationData);
      }
    } catch (e) {
      log("Failed to fetch notifications: $e");
    }
    return notificationList;
  }

/*
Updates the status of a registration request to indicate approval by the admin and retrieves the current document data.

@param date - The date associated with the notification (document ID in "Notifications").
@param time - The specific time for the notification (document ID in "AdminNotifications").
@param name - The name of the user for whom the request is updated (not used directly in this method).
@return Future<Map<String, dynamic>> - Returns the document data as a `Map` before the update if successful; returns an empty `Map` in case of an error.
@throws Exception - Prints an error message if an exception occurs during the Firestore operations.
*/
  Future<Map<String, dynamic>> registrationAllowedByAdmin(
      String date, String time, String name) async {
    Map<String, dynamic> data = {};
    try {   
      DocumentReference reference = FirebaseFirestore.instance
          .collection("Notifications")
          .doc(date)
          .collection("AdminNotifications")
          .doc(time);

      DocumentSnapshot docRef = await reference.get();
      data.addAll(docRef.data() as Map<String, dynamic>);
      reference.delete();
      return data;
    } catch (e) {
      log("Error while updating registration status: $e");
      return {};
    }
  }

/*This method is responsible for actual registration in the database 
@param  map that holds the data
@return if secess return true otherwise false
*/
  Future<bool> registerStudentWithCredentials(Map<String, dynamic> data) async {
    try {
      String studentID = await getStudentID();
      if (studentID.isEmpty) {
        return false;
      }

      String name = data["name"] ?? "";
      List<String> splitted = name.split(" ");

      if (splitted.length < 2) {
        return false;
      }

      String email = "${splitted[0]}${splitted[1]}$studentID@student.vu.com";

      await Authservice().creaAcountWithEmailAndPassword(email, email);

      // Save student data to Firestore
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(studentID)
          .set({
        ...data,
        "email": email,
        "password":
            email, // Avoid storing raw passwords; this is just an example
      });

      return true;
    } catch (e) {
      log("Error while registering student: $e");
      return false;
    }
  }


}
