import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirebaseAdminNotificationsController {
  Future<void> setNotificationAdmin(
      String who, Map<String, String> data) async {
    String formatedDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = DateFormat('HH:mm a').format(DateTime.now());
    await FirebaseFirestore.instance
        .collection("Notifications")
        .doc(formatedDateTime)
        .collection(who)
        .doc(time)
        .set(data);
  }

  List<Map<String, dynamic>> firebaseAdminNotificationsHistory = [];
  Future<List<Map<String, dynamic>>> fetchNotificationHistory() async {
    List<String> who = ["FacultyNotification", "StudentNotification"];

    try {
      QuerySnapshot dateDocsSnapshot =
          await FirebaseFirestore.instance.collection('Notifications').get();

      List dateDocs = dateDocsSnapshot.docs;
      for (var dateDoc in dateDocs) {
        String dateId = dateDoc.id; // Date document ID

        for (var individual in who) {
          QuerySnapshot timeDocsSnapshot = await FirebaseFirestore.instance
              .collection('Notifications')
              .doc(dateId)
              .collection(individual)
              .get();

          for (var timeDoc in timeDocsSnapshot.docs) {
            // Add each notification document data with its time field
            firebaseAdminNotificationsHistory.add({
              ...timeDoc.data() as Map<String, dynamic>,
              "time": timeDoc.id
            });
          }
        }
      }
    } catch (e) {
      log("Error fetching notifications: $e");
    }
    return firebaseAdminNotificationsHistory;
  }
}
